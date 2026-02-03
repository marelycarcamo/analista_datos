-- Verifica engines y si las tablas existen
SELECT 
    TABLE_NAME,
    ENGINE,
    TABLE_ROWS,
    CREATE_TIME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('dim_producto', 'dim_categoria', 'dim_marca');
  
  -- Primero, asegura que todas sean InnoDB
ALTER TABLE dim_categoria ENGINE = InnoDB;
ALTER TABLE dim_marca ENGINE = InnoDB;
ALTER TABLE dim_producto ENGINE = InnoDB;

-- Verifica que se crearon
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'dim_producto'
  AND REFERENCED_TABLE_NAME IS NOT NULL;