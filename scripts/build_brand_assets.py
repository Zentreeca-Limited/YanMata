#!/usr/bin/env python3
"""
YanMata Brand Asset Generator
Generates high-resolution refined brand assets, mobile app icons, splash screens,
web favicons, and UI components from the YanMata brand identity.
"""

import os
import io
import base64
from collections import deque
import numpy as np
from PIL import Image, ImageFilter, ImageEnhance, ImageOps

SRC_IMAGE = "/Users/user/.gemini/antigravity/brain/64dcd39e-9d57-42eb-8efe-cf45addae728/.user_uploaded/media_1793171869417_4802eb79.png"
REPO_ROOT = "/Users/user/WebProjects/YanMata - Apps"

def extract_and_refine_logo():
    print("[1/6] Extracting transparent master logo with anti-aliasing...")
    im = Image.open(SRC_IMAGE).convert("RGBA")
    arr = np.array(im, dtype=np.float32)
    H, W, _ = arr.shape

    r, g, b = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2]
    lum = 0.299 * r + 0.587 * g + 0.114 * b
    chroma = np.maximum(np.maximum(r, g), b) - np.minimum(np.minimum(r, g), b)

    # Pure white background: chroma <= 6.0 and lum >= 250.0
    is_pure_bg = (chroma <= 6.0) & (lum >= 250.0)

    # Flood fill from image perimeter
    is_outer_bg = np.zeros((H, W), dtype=bool)
    q = deque()
    for y in range(H):
        if is_pure_bg[y, 0]: q.append((y, 0)); is_outer_bg[y, 0] = True
        if is_pure_bg[y, W-1]: q.append((y, W-1)); is_outer_bg[y, W-1] = True
    for x in range(W):
        if is_pure_bg[0, x] and not is_outer_bg[0, x]: q.append((0, x)); is_outer_bg[0, x] = True
        if is_pure_bg[H-1, x] and not is_outer_bg[H-1, x]: q.append((H-1, x)); is_outer_bg[H-1, x] = True

    while q:
        cy, cx = q.popleft()
        for dy, dx in [(-1,0), (1,0), (0,-1), (0,1)]:
            ny, nx = cy + dy, cx + dx
            if 0 <= ny < H and 0 <= nx < W:
                if not is_outer_bg[ny, nx] and is_pure_bg[ny, nx]:
                    is_outer_bg[ny, nx] = True
                    q.append((ny, nx))

    full_bg = is_outer_bg.copy()
    # Below Y=420 (text area), pure white pixels inside letter counter loops are also transparent
    full_bg[420:, :] = full_bg[420:, :] | is_pure_bg[420:, :]

    # Smooth anti-aliased edge mask
    mask_im = Image.fromarray((~full_bg).astype(np.uint8) * 255)
    smooth_mask = mask_im.filter(ImageFilter.GaussianBlur(radius=0.6))
    smooth_arr = np.array(smooth_mask, dtype=np.float32)

    alpha = np.clip(smooth_arr, 0, 255)
    alpha[~full_bg & (smooth_arr > 240)] = 255.0

    # Un-premultiply fringe pixels against white background (254, 254, 254)
    a_norm = alpha / 255.0
    fringe_mask = (alpha > 0) & (alpha < 255)
    for c in range(3):
        channel = arr[:, :, c]
        fg = np.where(fringe_mask, (channel - (1.0 - a_norm) * 254.0) / np.maximum(a_norm, 0.05), channel)
        arr[:, :, c] = np.clip(fg, 0, 255)

    arr[:, :, 3] = alpha
    logo_trans = Image.fromarray(arr.astype(np.uint8))

    # Crop elements
    emblem_raw = logo_trans.crop((324, 68, 704, 422))
    wordmark_raw = logo_trans.crop((206, 440, 816, 558))
    tagline_raw = logo_trans.crop((216, 572, 814, 616))

    # 2x upscale with Lanczos + subtle unsharp masking for ultra-crisp resolution
    def enhance_element(im, scale=2.0, unsharp=True, sat_boost=1.05, con_boost=1.03):
        target_size = (int(im.width * scale), int(im.height * scale))
        u = im.resize(target_size, Image.Resampling.LANCZOS)
        if unsharp:
            u = u.filter(ImageFilter.UnsharpMask(radius=1.3, percent=125, threshold=2))
        if sat_boost != 1.0:
            u = ImageEnhance.Color(u).enhance(sat_boost)
        if con_boost != 1.0:
            u = ImageEnhance.Contrast(u).enhance(con_boost)
        return u

    emblem_2x = enhance_element(emblem_raw, scale=2.0, sat_boost=1.06, con_boost=1.03)
    wordmark_2x = enhance_element(wordmark_raw, scale=2.0, sat_boost=1.02, con_boost=1.02)
    tagline_2x = enhance_element(tagline_raw, scale=2.0, sat_boost=1.02, con_boost=1.02)

    return emblem_2x, wordmark_2x, tagline_2x

def create_brand_variants(emblem_2x, wordmark_2x, tagline_2x):
    print("[2/6] Building high-resolution brand suite variants...")

    # 1. Master Emblem (1024x1024 transparent)
    master_emblem_1024 = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
    scale_fit = min(880 / emblem_2x.width, 880 / emblem_2x.height)
    emb_fit = emblem_2x.resize((int(emblem_2x.width * scale_fit), int(emblem_2x.height * scale_fit)), Image.Resampling.LANCZOS)
    ex = (1024 - emb_fit.width) // 2
    ey = (1024 - emb_fit.height) // 2
    master_emblem_1024.paste(emb_fit, (ex, ey), emb_fit)

    # 2. Dark mode text elements (pearl / soft lilac #f8f2fa)
    def make_dark_mode_text(im):
        arr = np.array(im).copy()
        arr[:, :, 0] = 248  # R
        arr[:, :, 1] = 242  # G
        arr[:, :, 2] = 250  # B
        return Image.fromarray(arr)

    wordmark_dark = make_dark_mode_text(wordmark_2x)
    tagline_dark = make_dark_mode_text(tagline_2x)

    # 3. Stacked / Vertical Logo (1600x1400)
    canvas_w, canvas_h = 1600, 1400
    logo_full_light = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    y = 120
    logo_full_light.paste(emblem_2x, ((canvas_w - emblem_2x.width) // 2, y), emblem_2x)
    y += emblem_2x.height + 50
    logo_full_light.paste(wordmark_2x, ((canvas_w - wordmark_2x.width) // 2, y), wordmark_2x)
    y += wordmark_2x.height + 32
    logo_full_light.paste(tagline_2x, ((canvas_w - tagline_2x.width) // 2, y), tagline_2x)

    logo_full_dark = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    y = 120
    logo_full_dark.paste(emblem_2x, ((canvas_w - emblem_2x.width) // 2, y), emblem_2x)
    y += emblem_2x.height + 50
    logo_full_dark.paste(wordmark_dark, ((canvas_w - wordmark_dark.width) // 2, y), wordmark_dark)
    y += wordmark_dark.height + 32
    logo_full_dark.paste(tagline_dark, ((canvas_w - tagline_dark.width) // 2, y), tagline_dark)

    # 4. Horizontal / Landscape Logo (2000x560)
    scale_h_emb = 480 / emblem_2x.height
    h_emb = emblem_2x.resize((int(emblem_2x.width * scale_h_emb), 480), Image.Resampling.LANCZOS)
    scale_h_wrd = 160 / wordmark_2x.height
    h_wrd = wordmark_2x.resize((int(wordmark_2x.width * scale_h_wrd), 160), Image.Resampling.LANCZOS)
    h_wrd_dark = wordmark_dark.resize((int(wordmark_dark.width * scale_h_wrd), 160), Image.Resampling.LANCZOS)
    scale_h_tag = 50 / tagline_2x.height
    h_tag = tagline_2x.resize((int(tagline_2x.width * scale_h_tag), 50), Image.Resampling.LANCZOS)
    h_tag_dark = tagline_dark.resize((int(tagline_dark.width * scale_h_tag), 50), Image.Resampling.LANCZOS)

    h_w, h_h = 2000, 560
    logo_horiz_light = Image.new("RGBA", (h_w, h_h), (0, 0, 0, 0))
    logo_horiz_light.paste(h_emb, (70, (h_h - h_emb.height) // 2), h_emb)
    rx = 70 + h_emb.width + 60
    th = h_wrd.height + 24 + h_tag.height
    ty = (h_h - th) // 2
    logo_horiz_light.paste(h_wrd, (rx, ty), h_wrd)
    logo_horiz_light.paste(h_tag, (rx, ty + h_wrd.height + 24), h_tag)

    logo_horiz_dark = Image.new("RGBA", (h_w, h_h), (0, 0, 0, 0))
    logo_horiz_dark.paste(h_emb, (70, (h_h - h_emb.height) // 2), h_emb)
    logo_horiz_dark.paste(h_wrd_dark, (rx, ty), h_wrd_dark)
    logo_horiz_dark.paste(h_tag_dark, (rx, ty + h_wrd.height + 24), h_tag_dark)

    # 5. Master Mobile App Icons (1024x1024 solid RGB)
    icon_size = 1024
    app_icon_plum = Image.new("RGBA", (icon_size, icon_size), (0, 0, 0, 255))
    cx, cy = icon_size / 2, icon_size / 2
    y_c, x_c = np.ogrid[:icon_size, :icon_size]
    dist = np.sqrt((x_c - cx)**2 + (y_c - cy)**2) / (icon_size * 0.707)
    dist = np.clip(dist, 0.0, 1.0)

    # Radiant plum/rose aura gradient
    arr_plum = np.zeros((icon_size, icon_size, 4), dtype=np.uint8)
    arr_plum[:, :, 0] = (92 * (1 - dist) + 40 * dist).astype(np.uint8)
    arr_plum[:, :, 1] = (28 * (1 - dist) + 12 * dist).astype(np.uint8)
    arr_plum[:, :, 2] = (118 * (1 - dist) + 60 * dist).astype(np.uint8)
    arr_plum[:, :, 3] = 255
    bg_plum = Image.fromarray(arr_plum)

    # Fit emblem with safe margins (82% scale)
    emb_app = master_emblem_1024.resize((int(icon_size * 0.82), int(icon_size * 0.82)), Image.Resampling.LANCZOS)
    bg_plum.paste(emb_app, ((icon_size - emb_app.width) // 2, (icon_size - emb_app.height) // 2), emb_app)
    app_icon_plum = bg_plum.convert("RGB")

    # Light app icon (warm pearl blush #fff9fc to #f5e4ed)
    arr_light = np.zeros((icon_size, icon_size, 4), dtype=np.uint8)
    arr_light[:, :, 0] = (255 * (1 - dist) + 248 * dist).astype(np.uint8)
    arr_light[:, :, 1] = (248 * (1 - dist) + 234 * dist).astype(np.uint8)
    arr_light[:, :, 2] = (252 * (1 - dist) + 244 * dist).astype(np.uint8)
    arr_light[:, :, 3] = 255
    bg_light = Image.fromarray(arr_light)
    bg_light.paste(emb_app, ((icon_size - emb_app.width) // 2, (icon_size - emb_app.height) // 2), emb_app)
    app_icon_light = bg_light.convert("RGB")

    # 6. SVG Favicon (crisp 256x256 base64 embedded vector wrapper)
    emb_256 = master_emblem_1024.resize((256, 256), Image.Resampling.LANCZOS)
    buf = io.BytesIO()
    emb_256.save(buf, format="PNG", optimize=True)
    b64_data = base64.b64encode(buf.getvalue()).decode("utf-8")
    svg_favicon = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="100%" height="100%">
  <title>YanMata • Healthy Women. Brighter Futures.</title>
  <image href="data:image/png;base64,{b64_data}" width="256" height="256" />
</svg>"""

    return {
        "emblem": master_emblem_1024,
        "logo_full_light": logo_full_light,
        "logo_full_dark": logo_full_dark,
        "logo_horiz_light": logo_horiz_light,
        "logo_horiz_dark": logo_horiz_dark,
        "app_icon_plum": app_icon_plum,
        "app_icon_light": app_icon_light,
        "svg_favicon": svg_favicon,
    }

def deploy_assets(assets):
    print("[3/6] Deploying brand assets to packages/ui/assets/brand...")
    brand_dir = os.path.join(REPO_ROOT, "packages/ui/assets/brand")
    os.makedirs(brand_dir, exist_ok=True)

    assets["emblem"].save(os.path.join(brand_dir, "yanmata_emblem.png"))
    assets["logo_full_light"].save(os.path.join(brand_dir, "yanmata_logo_full.png"))
    assets["logo_full_dark"].save(os.path.join(brand_dir, "yanmata_logo_full_dark.png"))
    assets["logo_horiz_light"].save(os.path.join(brand_dir, "yanmata_logo_horizontal.png"))
    assets["logo_horiz_dark"].save(os.path.join(brand_dir, "yanmata_logo_horizontal_dark.png"))
    assets["app_icon_plum"].save(os.path.join(brand_dir, "yanmata_app_icon.png"))
    assets["app_icon_light"].save(os.path.join(brand_dir, "yanmata_app_icon_light.png"))
    with open(os.path.join(brand_dir, "yanmata_emblem.svg"), "w") as f:
        f.write(assets["svg_favicon"])

    print("[4/6] Deploying assets to mobile app (assets, splash, Android & iOS app icons)...")
    mobile_assets_dir = os.path.join(REPO_ROOT, "apps/mobile/assets")
    os.makedirs(mobile_assets_dir, exist_ok=True)
    assets["emblem"].save(os.path.join(mobile_assets_dir, "logo.png"))
    assets["logo_full_light"].save(os.path.join(mobile_assets_dir, "logo_full.png"))
    assets["logo_horiz_light"].save(os.path.join(mobile_assets_dir, "logo_horizontal.png"))

    # Android splash / launch logos
    android_res = os.path.join(REPO_ROOT, "apps/mobile/android/app/src/main/res")
    nodpi_dir = os.path.join(android_res, "drawable-nodpi")
    os.makedirs(nodpi_dir, exist_ok=True)
    assets["emblem"].save(os.path.join(nodpi_dir, "launch_logo.png"))
    assets["emblem"].save(os.path.join(nodpi_dir, "splash_logo.png"))

    # Android mipmaps
    mipmap_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, sz in mipmap_sizes.items():
        fpath = os.path.join(android_res, folder)
        os.makedirs(fpath, exist_ok=True)
        icon_res = assets["app_icon_plum"].resize((sz, sz), Image.Resampling.LANCZOS)
        icon_res.save(os.path.join(fpath, "ic_launcher.png"))

    # iOS AppIcons
    ios_icon_dir = os.path.join(REPO_ROOT, "apps/mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset")
    os.makedirs(ios_icon_dir, exist_ok=True)
    ios_sizes = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    for filename, sz in ios_sizes.items():
        ios_icon = assets["app_icon_plum"].resize((sz, sz), Image.Resampling.LANCZOS)
        ios_icon.save(os.path.join(ios_icon_dir, filename))

    print("[5/6] Deploying web & admin public assets (favicons, logos, touch icons)...")
    for app_name in ["web", "admin"]:
        pub_dir = os.path.join(REPO_ROOT, f"apps/{app_name}/public")
        os.makedirs(pub_dir, exist_ok=True)
        assets["emblem"].save(os.path.join(pub_dir, "logo.png"))
        assets["logo_full_light"].save(os.path.join(pub_dir, "logo_full.png"))
        assets["logo_horiz_light"].save(os.path.join(pub_dir, "logo_horizontal.png"))
        with open(os.path.join(pub_dir, "favicon.svg"), "w") as f:
            f.write(assets["svg_favicon"])
        
        # Multi-res favicon.ico
        ico_sizes = [(16, 16), (32, 32), (48, 48), (64, 64)]
        assets["app_icon_plum"].save(os.path.join(pub_dir, "favicon.ico"), format="ICO", sizes=ico_sizes)

        # Apple Touch Icon
        apple_touch = assets["app_icon_plum"].resize((180, 180), Image.Resampling.LANCZOS)
        apple_touch.save(os.path.join(pub_dir, "apple-touch-icon.png"))

    print("[6/6] All brand assets successfully generated and deployed!")

if __name__ == "__main__":
    emblem_2x, wordmark_2x, tagline_2x = extract_and_refine_logo()
    assets = create_brand_variants(emblem_2x, wordmark_2x, tagline_2x)
    deploy_assets(assets)
