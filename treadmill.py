#!/usr/bin/env python3
"""
treadmill.py – Control a SuperFit “Gymax” treadmill via BLE.

The script reproduces the raw ATT Write Requests you extracted with gatttool:

    wake   -> a9 08 04 05 01 05 06 a2
    start  -> a9 a3 01 01 0a
    stop   -> a9 a3 01 00 0b
    up     -> a9 01 01 07 ae
    down   -> a9 01 01 06 af

Usage example (run as normal user, no sudo needed):
    python3 treadmill.py --mac FD:77:39:FD:4D:F3 start
"""

import argparse
import asyncio
import sys
from typing import Dict

from bleak import BleakClient, BleakGATTCharacteristic, BleakScanner

# ----------------------------------------------------------------------
# Mapping from CLI keyword → raw byte payload (as a bytes literal)
# ----------------------------------------------------------------------
COMMANDS: Dict[str, bytes] = {
    "wake":  bytes.fromhex("a9 08 04 05 01 05 06 a2"),
    "start": bytes.fromhex("a9 a3 01 01 0a"),
    "stop":  bytes.fromhex("a9 a3 01 00 0b"),
    "up":    bytes.fromhex("a9 01 01 07 ae"),
    "down":  bytes.fromhex("a9 01 01 06 af"),
}

# The GATT handle that the Gymax app writes to (found in your log)
WRITE_HANDLE = 0x0005


# ----------------------------------------------------------------------
# Async helper that performs the BLE write
# ----------------------------------------------------------------------
async def send_command(mac: str, payload: bytes, debug: bool = False) -> None:
    """
    Connect to *mac*, write *payload* to WRITE_HANDLE, then disconnect.
    """
    device = await BleakScanner.find_device_by_address(
        mac
    )
    if device is None:
        print("Error: could not find device with address '%s'", mac)
        return

    if debug:
        print(f"[DEBUG] Connecting to {mac} …")
    async with BleakClient(device) as client:
        if debug:
            for service in client.services:
                print("[Service] %s", service)

                for char in service.characteristics:
                    if "read" in char.properties:
                        try:
                            value = await client.read_gatt_char(char)
                            extra = f", Value: {value}"
                        except Exception as e:
                            extra = f", Error: {e}"
                    else:
                        extra = ""

                    if "write-without-response" in char.properties:
                        extra += f", Max write w/o rsp size: {char.max_write_without_response_size}"

                    print(
                        "  [Characteristic] %s (%s)%s",
                        char,
                        ",".join(char.properties),
                        extra,
                    )

                    for descriptor in char.descriptors:
                        try:
                            value = await client.read_gatt_descriptor(descriptor)
                            print("    [Descriptor] %s, Value: %r", descriptor, value)
                        except Exception as e:
                            print("    [Descriptor] %s, Error: %s", descriptor, e)




        if debug:
            for service in client.services:
                print("f[DEBUG] Service:", service)
            print(f"[DEBUG] Connected. Writing {len(payload)} byte(s) to handle "
                  f"0x{WRITE_HANDLE:04x}: {payload.hex()}")

        await client.write_gatt_char(WRITE_HANDLE, payload, response=True)

        if debug:
            print("[DEBUG] Write completed, disconnecting…" )
    # Context manager closes the connection automatically.


# ----------------------------------------------------------------------
# Argument parsing and entry point
# ----------------------------------------------------------------------
def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Control a SuperFit Gymax treadmill via BLE."
    )
    parser.add_argument(
        "--mac",
        required=True,
        help="Bluetooth MAC address of the treadmill (e.g. FD:77:39:FD:4D:F3)",
    )
    parser.add_argument(
        "action",
        choices=sorted(COMMANDS.keys()),
        help="What you want the treadmill to do",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Print extra diagnostic information",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    payload = COMMANDS[args.action]

    try:
        asyncio.run(send_command(args.mac, payload, debug=args.debug))
    except Exception as exc:                     # pragma: no cover – runtime guard
        print(f"❌  Failed: {exc}", file=sys.stderr)
        return 1

    print(f"✅  Command '{args.action}' sent successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
