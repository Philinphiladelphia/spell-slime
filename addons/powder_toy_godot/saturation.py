import json

def rgb_to_hsv(r, g, b):
    maxc = max(r, g, b)
    minc = min(r, g, b)
    v = maxc
    if minc == maxc:
        return 0.0, 0.0, v
    s = (maxc - minc) / maxc
    rc = (maxc - r) / (maxc - minc)
    gc = (maxc - g) / (maxc - minc)
    bc = (maxc - b) / (maxc - minc)
    if r == maxc:
        h = bc - gc
    elif g == maxc:
        h = 2.0 + rc - bc
    else:
        h = 4.0 + gc - rc
    h = (h / 6.0) % 1.0
    return h, s, v

def hsv_to_rgb(h, s, v):
    if s == 0.0:
        return v, v, v
    i = int(h * 6.0)
    f = (h * 6.0) - i
    p = v * (1.0 - s)
    q = v * (1.0 - s * f)
    t = v * (1.0 - s * (1.0 - f))
    i = i % 6
    if i == 0:
        return v, t, p
    if i == 1:
        return q, v, p
    if i == 2:
        return p, v, t
    if i == 3:
        return p, q, v
    if i == 4:
        return t, p, v
    if i == 5:
        return v, p, q

def adjust_saturation(color):
    r, g, b, a = color
    h, s, v = rgb_to_hsv(r, g, b)
    s = 1.0  # Increase saturation to 1
    r, g, b = hsv_to_rgb(h, s, v)
    return r, g, b, a

with open('colors.json', 'r') as file:
    colors = json.load(file)

adjusted_colors = {}
for key, value in colors.items():
    color = eval(value.replace("Color", ""))
    adjusted_color = adjust_saturation(color)
    adjusted_colors[key] = f"Color({adjusted_color[0]}, {adjusted_color[1]}, {adjusted_color[2]}, {adjusted_color[3]})"

with open('colors_adjusted.json', 'w') as file:
    json.dump(adjusted_colors, file, indent=4)