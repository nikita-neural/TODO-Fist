#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os

def create_app_icon(size, filename):
    """Создает иконку приложения в стиле статус-бара"""
    # Создаем изображение с прозрачным фоном
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Размеры для адаптации под разные размеры
    padding = max(size // 20, 2)
    corner_radius = size // 8
    
    # Основной квадрат с скругленными углами (синий градиент имитируем)
    main_rect = [padding, padding, size - padding, size - padding]
    
    # Рисуем основной прямоугольник с синим цветом
    blue_color = (102, 126, 234, 255)  # #667eea
    draw.rounded_rectangle(main_rect, radius=corner_radius, fill=blue_color)
    
    # Добавляем небольшой градиентный эффект (светлее сверху)
    light_blue = (118, 139, 162, 80)  # #764ba2 с прозрачностью
    gradient_rect = [padding, padding, size - padding, size // 2]
    draw.rounded_rectangle(gradient_rect, radius=corner_radius, fill=light_blue)
    
    # Рисуем галочку (белая)
    check_color = (255, 255, 255, 255)
    
    # Размеры галочки пропорциональны размеру иконки
    check_size = size * 0.4
    center_x = size // 2
    center_y = size // 2
    
    # Координаты для галочки
    stroke_width = max(size // 20, 3)
    
    # Левая часть галочки (короткая линия)
    left_start_x = center_x - check_size // 3
    left_start_y = center_y
    left_end_x = center_x - check_size // 6
    left_end_y = center_y + check_size // 4
    
    # Правая часть галочки (длинная линия)
    right_start_x = left_end_x
    right_start_y = left_end_y
    right_end_x = center_x + check_size // 2
    right_end_y = center_y - check_size // 3
    
    # Рисуем галочку жирными линиями
    draw.line([left_start_x, left_start_y, left_end_x, left_end_y], 
              fill=check_color, width=stroke_width)
    draw.line([right_start_x, right_start_y, right_end_x, right_end_y], 
              fill=check_color, width=stroke_width)
    
    # Добавляем небольшую тень для объема
    shadow_color = (0, 0, 0, 40)
    shadow_offset = max(size // 40, 1)
    shadow_rect = [padding + shadow_offset, padding + shadow_offset, 
                   size - padding + shadow_offset, size - padding + shadow_offset]
    
    # Создаем отдельное изображение для тени
    shadow_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_img)
    shadow_draw.rounded_rectangle(shadow_rect, radius=corner_radius, fill=shadow_color)
    
    # Накладываем тень под основную иконку
    final_img = Image.alpha_composite(shadow_img, img)
    
    # Сохраняем
    final_img.save(filename, 'PNG')
    print(f"Создана иконка: {filename} ({size}x{size})")

def main():
    """Создает иконки приложения для всех размеров"""
    
    # Создаем папку для иконок если её нет
    icons_dir = "app_icons"
    if not os.path.exists(icons_dir):
        os.makedirs(icons_dir)
    
    # Размеры для разных платформ
    sizes = [
        # Android
        (48, f"{icons_dir}/android_48.png"),
        (72, f"{icons_dir}/android_72.png"),
        (96, f"{icons_dir}/android_96.png"),
        (144, f"{icons_dir}/android_144.png"),
        (192, f"{icons_dir}/android_192.png"),
        
        # iOS
        (29, f"{icons_dir}/ios_29.png"),
        (40, f"{icons_dir}/ios_40.png"),
        (58, f"{icons_dir}/ios_58.png"),
        (60, f"{icons_dir}/ios_60.png"),
        (80, f"{icons_dir}/ios_80.png"),
        (87, f"{icons_dir}/ios_87.png"),
        (120, f"{icons_dir}/ios_120.png"),
        (180, f"{icons_dir}/ios_180.png"),
        
        # Универсальные размеры
        (512, f"{icons_dir}/icon_512.png"),
        (1024, f"{icons_dir}/icon_1024.png"),
    ]
    
    print("Создание иконок приложения в стиле статус-бара...")
    
    for size, filename in sizes:
        create_app_icon(size, filename)
    
    print(f"\nВсе иконки созданы в папке '{icons_dir}'!")
    print("Теперь используйте flutter_launcher_icons для обновления иконок приложения.")

if __name__ == "__main__":
    main()
