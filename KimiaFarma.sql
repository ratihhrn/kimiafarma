-- Create a table "analysis_table" based on the aggregation of the four tables.
CREATE TABLE myskill-da11-449111.kimiafarma.tabel_analisa AS
WITH main AS (
    SELECT 
        t.transaction_id,
        t.date,
        t.branch_id,
        kc.branch_name,
        kc.kota,
        kc.provinsi,
        kc.rating AS rating_cabang,
        t.customer_name,
        t.product_id,
        p.product_name,
        p.price AS actual_price,
        t.discount_percentage,
        -- Calculating gross profit percentage based on drug price
        CASE 
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba,
        -- Calculating the price after discount (net sales)
        (p.price * (1 - t.discount_percentage)) AS nett_sales,
        -- Calculating profit (nett_profit)
        (p.price * (1 - t.discount_percentage)) * 
        (CASE 
            WHEN p.price <= 50000 THEN 0.10
            WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
            WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
            WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
            ELSE 0.30
        END) AS nett_profit,
        t.rating AS rating_transaksi
    FROM `kimiafarma.kf_final_transaction` t
    JOIN `kimiafarma.kf_kantor_cabang` kc
        ON t.branch_id = kc.branch_id
    JOIN `kimiafarma.kf_product` p
        ON t.product_id = p.product_id
)

SELECT * FROM main
ORDER BY date DESC;
