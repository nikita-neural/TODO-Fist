#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os
import math

def create_smooth_gradient(width, height, color1, color2):
    """Создает плавный градиент между двумя цветами"""
    gradient = Image.new('RGBA', (width, height))
    draw = ImageDraw.Draw(gradient)
    
    for y in range(height):
        # Интерполяция между цветами
        ratio = y / height
        r = int(color1[0] + (color2[0] - color1[0]) * ratio)
        g = int(color1[1] + (color2[1] - color1[1]) * ratio)
        b = int(color1[2] + (color2[2] - color1[2]) * ratio)
        
        draw.line([(0, y), (width, y)], fill=(r, g, b, 255))
    
    return gradient

def create_soft_mask(size, corner_radius):
    """Создает мягкую маску с плавными краями"""
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    
    # Основная форма
    draw.rounded_rectangle([0, 0, size, size], radius=corner_radius, fill=255)
    
    return mask

def create_elegant_checkmark(size, padding):
    """Создает элегантную галочку с мягкими линиями"""
    check_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(check_img)
    
    # Параметры галочки
    check_area = size - 2 * padding
    center_x = size // 2
    center_y = size // 2
    
    # Координаты для более плавной галочки
    scale = check_area / 100.0  # Масштабируем под размер
    
    # Левая часть галочки
    left_start = (center_x - 15 * scale, center_y + 2 * scale)
    left_end = (center_x - 5 * scale, center_y + 12 * scale)
    
    # Правая часть галочки
    right_start = left_end
    right_end = (center_x + 18 * scale, center_y - 10 * scale)
    
    # Толщина линии пропорциональна размеру
    line_width = max(3, int(size * 0.08))
    
    # Добавляем легкую тень для объема
    shadow_offset = max(1, size // 60)
    shadow_alpha = 60
    
    # Рисуем тень галочки
    draw.line([
        (left_start[0] + shadow_offset, left_start[1] + shadow_offset),
        (left_end[0] + shadow_offset, left_end[1] + shadow_offset)
    ], fill=(0, 0, 0, shadow_alpha), width=line_width)
    
    draw.line([
        (right_start[0] + shadow_offset, right_start[1] + shadow_offset),
        (right_end[0] + shadow_offset, right_end[1] + shadow_offset)
    ], fill=(0, 0, 0, shadow_alpha), width=line_width)
    
    # Основная белая галочка
    draw.line([left_start, left_end], fill=(255, 255, 255, 255), width=line_width)
    draw.line([right_start, right_end], fill=(255, 255, 255, 255), width=line_width)
    
    return check_img

def create_app_icon(size, filename):
    """Создает красивую иконку приложения с мягкими краями"""
    
    # Основные параметры
    padding = size // 16  # Минимальные отступы для более полной иконки
    icon_size = size - 2 * padding
    corner_radius = size // 3.5  # Более мягкие углы
    
    # Цвета градиента (как на splash screen)
    color1 = (102, 126, 234)  # #667eea (верх)
    color2 = (118, 75, 162)   # #764ba2 (низ)
    
    # Создаем градиентный фон
    gradient = create_smooth_gradient(icon_size, icon_size, color1, color2)
    
    # Добавляем блик для объема
    highlight = Image.new('RGBA', (icon_size, icon_size), (0, 0, 0, 0))
    highlight_draw = ImageDraw.Draw(highlight)
    
    # Создаем эллиптический блик в верхней части
    highlight_size_w = icon_size // 2
    highlight_size_h = icon_size // 4
    highlight_x = icon_size // 4
    highlight_y = icon_size // 8
    
    highlight_draw.ellipse([
        highlight_x, highlight_y, 
        highlight_x + highlight_size_w, highlight_y + highlight_size_h
    ], fill=(255, 255, 255, 25))
    
    # Совмещаем градиент с бликом
    gradient_with_highlight = Image.alpha_composite(gradient.convert('RGBA'), highlight)
    
    # Создаем финальное изображение
    final_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    # Вставляем градиентный фон в центр
    final_img.paste(gradient_with_highlight, (padding, padding))
    
    # Применяем мягкую маску
    mask = create_soft_mask(size, corner_radius)
    final_img.putalpha(mask)
    
    # Добавляем элегантную галочку
    checkmark = create_elegant_checkmark(size, size // 4)
    final_img = Image.alpha_composite(final_img, checkmark)
    
    # Добавляем тонкую тень под иконку для глубины
    shadow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_offset = max(2, size // 30)
    shadow_blur_radius = corner_radius + shadow_offset
    
    # Тень чуть больше основной формы
    shadow_draw.rounded_rectangle([
        shadow_offset, shadow_offset, 
        size + shadow_offset, size + shadow_offset
    ], radius=shadow_blur_radius, fill=(0, 0, 0, 30))
    
    # Финальная композиция: тень + иконка
    result = Image.alpha_composite(shadow, final_img)
    
    # Обрезаем до нужного размера (убираем лишнюю тень)
    result = result.crop((0, 0, size, size))
    
    # Сохраняем
    result.save(filename, 'PNG')
    print(f"✨ Создана элегантная иконка: {filename} ({size}x{size})")

def main():
    """Создает красивые иконки приложения для всех размеров"""
    
    # Создаем папку для иконок
    icons_dir = "app_icons_elegant"  # Новая папка для красивых иконок
    if not os.path.exists(icons_dir):
        os.makedirs(icons_dir)
    
    # Размеры иконок для всех платформ
    icon_sizes = [
        # Android
        (48, "android/res/mipmap-mdpi/ic_launcher.png"),
        (72, "android/res/mipmap-hdpi/ic_launcher.png"),
        (96, "android/res/mipmap-xhdpi/ic_launcher.png"),
        (144, "android/res/mipmap-xxhdpi/ic_launcher.png"),
        (192, "android/res/mipmap-xxxhdpi/ic_launcher.png"),
        
        # iOS
        (20, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png"),
        (40, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png"),
        (60, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png"),
        (58, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png"),
        (87, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png"),
        (80, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png"),
        (120, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png"),
        (120, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png"),
        (180, "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png"),
        
        # Универсальные размеры
        (512, "icon_512.png"),
        (1024, "icon_1024.png"),
    ]
    
    print("🎨 Создание элегантных иконок приложения...")
    print("=" * 50)
    
    for size, relative_path in icon_sizes:
        filename = os.path.join(icons_dir, f"icon_{size}.png")
        create_app_icon(size, filename)
    
    print("=" * 50)
    print("✅ Все элегантные иконки созданы успешно!")
    print(f"📁 Иконки сохранены в папке: {icons_dir}")
    print("\n🚀 Следующие шаги:")
    print("1. Скопируйте icon_1024.png в assets/icons/app_icon.png")
    print("2. Запустите: dart run flutter_launcher_icons")

if __name__ == "__main__":
    main()
