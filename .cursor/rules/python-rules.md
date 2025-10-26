# Python Rules for Cursor

Based on `100-programming-languages/101-python.mdc`:

## Core Principles

- Use src-layout project structure
- Follow PEP 8 and Black code style
- All functions use type hints
- Prefer async/await for asynchronous programming
- Flask apps use factory pattern and blueprints
- SQLAlchemy 2.0+ syntax

## Code Patterns

### Function Definition

```python
from typing import Optional, List
from sqlalchemy.orm import Session

async def get_users(
    db: Session,
    skip: int = 0,
    limit: int = 100
) -> List[User]:
    """获取用户列表"""
    return await db.execute(
        select(User).offset(skip).limit(limit)
    ).scalars().all()
```

### Flask Blueprint

```python
from flask import Blueprint, request, jsonify
from typing import Dict, Any

api = Blueprint('api', __name__, url_prefix='/api')

@api.route('/users', methods=['GET'])
async def get_users() -> Dict[str, Any]:
    """获取用户列表API"""
    # 实现逻辑
    return jsonify({"users": users})
```

### Error Handling

```python
from typing import Union, Dict, Any

class UserNotFoundError(Exception):
    """用户未找到异常"""
    pass

async def process_user(user_id: int) -> Union[User, Dict[str, str]]:
    try:
        user = await get_user(user_id)
        if not user:
            raise UserNotFoundError(f"User {user_id} not found")
        return user
    except UserNotFoundError as e:
        return {"error": str(e)}
```

## Tool Configuration

- Python 3.12+
- Flask 3.0+
- SQLAlchemy 2.0+
- pytest 7.0+
- Black 23.0+
