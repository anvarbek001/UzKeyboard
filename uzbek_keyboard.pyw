"""
O'zbek yangi alifbo klaviaturasi (Windows)

  o + '   -> ö / Ö
  g + '   -> ğ / Ğ
  s + h   -> ş / Ş
  c + h   -> ç / Ç

Ctrl+Alt+U  -> yoqish / o'chirish
"""
import ctypes
import sys

import keyboard  # pip install keyboard

APOSTROPHES = {"'", "’", "‘", "ʻ", "`"}
APOSTROPHE_RULES = {"o": "ö", "g": "ğ"}
H_RULES = {"s": "ş", "c": "ç"}

state = {"enabled": True, "last": "", "held": set()}

MUTEX_NAME = "UzKeyboardSingleInstanceMutex"
_mutex_handle = None


def ensure_single_instance() -> bool:
    """Dastur allaqachon ishlab turgan bo'lsa, False qaytaradi."""
    global _mutex_handle
    kernel32 = ctypes.windll.kernel32
    _mutex_handle = kernel32.CreateMutexW(None, False, MUTEX_NAME)
    return kernel32.GetLastError() != 183  # 183 = ERROR_ALREADY_EXISTS


def caps_on() -> bool:
    return bool(ctypes.windll.user32.GetKeyState(0x14) & 1)


def to_char(name: str) -> str:
    if name.isascii() and name.isalpha():
        upper = keyboard.is_pressed("shift") ^ caps_on()
        return name.upper() if upper else name.lower()
    return name


def replacement(prev: str, name: str):
    p = prev.lower()
    if name in APOSTROPHES:
        base = APOSTROPHE_RULES.get(p)
    elif name.lower() == "h":
        base = H_RULES.get(p)
    else:
        base = None
    if base is None:
        return None
    return base.upper() if prev.isupper() else base


def handle(event):
    name = event.name or ""

    if event.event_type == "up":
        state["held"].discard(name)
        return True

    # Tugma ushlab turilganda takror signallarni e'tiborsiz qoldirish
    if name in state["held"]:
        return True
    state["held"].add(name)

    # Dastur o'zi yozgan belgilar (ö, ş, ...) yoki Backspace kabi tugmalar
    if len(name) != 1 or not (name.isascii() or name in APOSTROPHES):
        state["last"] = ""
        return True

    if not state["enabled"]:
        state["last"] = ""
        return True

    ch = to_char(name)
    prev = state["last"]

    rep = replacement(prev, name) if prev else None
    if rep:
        keyboard.press_and_release("backspace")
        keyboard.write(rep)
        state["last"] = ""
        return False

    state["last"] = ch
    return True


def toggle():
    state["enabled"] = not state["enabled"]
    state["last"] = ""


if __name__ == "__main__":
    if not ensure_single_instance():
        sys.exit(0)  # Dastur allaqachon ishlayapti
    keyboard.hook(handle, suppress=True)
    keyboard.add_hotkey("ctrl+alt+u", toggle)
    keyboard.wait()
