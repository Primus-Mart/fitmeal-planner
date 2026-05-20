# E/R model

This implementation follows the FitMeal Planner project idea: users search foods, create meals, and track calories/macronutrients.

The relation name `app_user` is used instead of `User` because `user` is a reserved/awkward SQL identifier in PostgreSQL.

```mermaid
erDiagram
    APP_USER ||--o{ MEAL : creates
    APP_USER ||--o{ DAILY_LOG : has
    MEAL ||--o{ MEAL_ITEM : contains
    FOOD ||--o{ MEAL_ITEM : appears_in
    DAILY_LOG ||--o{ DAILY_LOG_MEAL : contains
    MEAL ||--o{ DAILY_LOG_MEAL : is_logged_as

    APP_USER {
        int user_id PK
        string name
        string email UK
        numeric weight_kg
        string goal_type
        int calorie_target
    }

    FOOD {
        int food_id PK
        string name UK
        numeric calories
        numeric protein
        numeric carbs
        numeric fats
        string source
    }

    MEAL {
        int meal_id PK
        int user_id FK
        string name
        string meal_type
        timestamp created_at
    }

    MEAL_ITEM {
        int meal_item_id PK
        int meal_id FK
        int food_id FK
        numeric quantity_grams
    }

    DAILY_LOG {
        int log_id PK
        int user_id FK
        date log_date
        numeric total_calories
        numeric total_protein
        numeric total_carbs
        numeric total_fats
    }

    DAILY_LOG_MEAL {
        int log_meal_id PK
        int log_id FK
        int meal_id FK
    }
```

## Mapping from the presentation diagram

The original presentation diagram contains the core entities `User`, `Food`, `Meal`, `MealItem`, and `Daily_Log`. This implementation keeps those core entities and adds `Daily_Log_Meal` as a bridge relation, because a daily log can contain many meals and the same meal can appear in many daily logs.

## SQL features demonstrated

- `SELECT`: food search, meal nutrition, daily dashboard
- `INSERT`: create meals, add foods to meals, create daily logs, log meals
- `DELETE`: remove meal items and logged meals
- Views: `meal_nutrition`, `daily_log_summary`
- Trigger: refreshes stored `daily_log.total_*` columns when meals are logged/unlogged
- Regular expression matching: Python route parses food search syntax such as `protein>=20 calories<300`
