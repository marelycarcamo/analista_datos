# Dimensiones para análisis de e-commerce
dimensiones_ecommerce = {
    'dim_customer': [
        'customer_id', 'email', 'registration_date',
        'customer_segment', 'total_orders', 'lifetime_value'
    ],
    'dim_product': [
        'product_id', 'sku', 'name', 'category',
        'brand', 'unit_cost', 'current_price'
    ],
    'dim_time': [
        'date_key', 'full_date', 'year', 'quarter',
        'month', 'day_of_week', 'is_weekend', 'is_holiday'
    ],
    'dim_location': [
        'location_id', 'country', 'region', 'city',
        'postal_code', 'timezone'
    ]
}

print("DIMENSIONES IDENTIFICADAS:")
for dim, atributos in dimensiones_ecommerce.items():
    print(f"• {dim}: {', '.join(atributos[:3])}...")