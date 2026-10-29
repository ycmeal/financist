"""Звон монеток для напоминаний: несколько монет падают одна на другую.

Собирается из синусов (у металла обертоны негармоничные) и короткого щелчка удара,
без чужих записей. Запуск: python3 tools/sounds/make_coins.py → Financist/Sounds/coins.wav.
Тот же файл встроен в прототип.
"""
import pathlib
import wave

import numpy as np

RATE = 44_100
LENGTH = 1.25
# Обертоны монеты: отношения к основному тону, громкость, сколько звенит (с).
PARTIALS = [(1.0, 1.0, 0.42), (2.32, 0.55, 0.30), (4.25, 0.32, 0.20), (6.63, 0.18, 0.13), (9.38, 0.08, 0.08)]
# Удары: когда, основной тон (Гц), громкость. Первая звонкая, потом монеты ложатся кучкой и затихают.
HITS = [(0.00, 2350, 1.00), (0.085, 2790, 0.80), (0.155, 2520, 0.72), (0.215, 3120, 0.55),
        (0.300, 2660, 0.48), (0.420, 2950, 0.32), (0.560, 2440, 0.20)]


def coin(t: np.ndarray, base: float, rng: np.random.Generator) -> np.ndarray:
    tone = np.zeros_like(t)
    for ratio, gain, decay in PARTIALS:
        f = base * ratio * (1 + rng.uniform(-0.01, 0.01))
        if f > RATE * 0.45:
            continue
        # Две близкие частоты дают металлическое «дрожание».
        tone += gain * np.exp(-t / decay) * (np.sin(2 * np.pi * f * t) + 0.6 * np.sin(2 * np.pi * f * 1.004 * t + 1.3))
    click = rng.normal(0, 1, t.size) * np.exp(-t / 0.0025) * 0.6
    attack = np.minimum(1, t / 0.0008)
    return (tone + click) * attack


def main() -> None:
    rng = np.random.default_rng(7)
    t = np.arange(int(RATE * LENGTH)) / RATE
    out = np.zeros_like(t)
    for start, base, gain in HITS:
        i = int(start * RATE)
        out[i:] += gain * coin(t[: t.size - i], base, rng)
    fade = np.clip((LENGTH - t) / 0.15, 0, 1)
    out *= fade
    out *= 0.89 / np.max(np.abs(out))
    path = pathlib.Path(__file__).resolve().parents[2] / "Financist/Sounds/coins.wav"
    with wave.open(str(path), "wb") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(RATE)
        f.writeframes((out * 32767).astype("<i2").tobytes())
    print(path, path.stat().st_size, "bytes")


if __name__ == "__main__":
    main()
