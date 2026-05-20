INSERT INTO app_user (name, email, weight_kg, goal_type, calorie_target) VALUES
('Demo User', 'demo@example.com', 80.0, 'maintenance', 2500)
ON CONFLICT (email) DO NOTHING;

INSERT INTO food (name, calories, protein, carbs, fats, source) VALUES
('Chicken breast, cooked', 165, 31.0, 0.0, 3.6, 'sample inspired by public nutrition datasets'),
('Salmon, cooked', 206, 22.0, 0.0, 12.0, 'sample inspired by public nutrition datasets'),
('White rice, cooked', 130, 2.7, 28.0, 0.3, 'sample inspired by public nutrition datasets'),
('Oats', 389, 16.9, 66.3, 6.9, 'sample inspired by public nutrition datasets'),
('Greek yogurt, plain', 59, 10.0, 3.6, 0.4, 'sample inspired by public nutrition datasets'),
('Banana', 89, 1.1, 22.8, 0.3, 'sample inspired by public nutrition datasets'),
('Avocado', 160, 2.0, 8.5, 14.7, 'sample inspired by public nutrition datasets'),
('Egg, whole', 143, 12.6, 0.7, 9.5, 'sample inspired by public nutrition datasets'),
('Broccoli, cooked', 35, 2.4, 7.2, 0.4, 'sample inspired by public nutrition datasets'),
('Olive oil', 884, 0.0, 0.0, 100.0, 'sample inspired by public nutrition datasets')
ON CONFLICT (name) DO NOTHING;

INSERT INTO meal (user_id, name, meal_type)
SELECT user_id, 'High protein lunch', 'lunch'
FROM app_user WHERE email = 'demo@example.com'
ON CONFLICT DO NOTHING;

INSERT INTO meal_item (meal_id, food_id, quantity_grams)
SELECT m.meal_id, f.food_id, v.quantity_grams
FROM meal m
JOIN app_user u ON u.user_id = m.user_id
JOIN (VALUES
    ('Chicken breast, cooked', 150.0),
    ('White rice, cooked', 180.0),
    ('Broccoli, cooked', 100.0)
) AS v(food_name, quantity_grams) ON TRUE
JOIN food f ON f.name = v.food_name
WHERE u.email = 'demo@example.com' AND m.name = 'High protein lunch';
