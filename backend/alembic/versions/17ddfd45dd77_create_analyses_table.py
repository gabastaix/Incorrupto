"""create analyses table

Revision ID: 17ddfd45dd77
Revises: 402a9cfa6b8c
Create Date: 2026-04-29 23:56:52.414558

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '17ddfd45dd77'
down_revision: Union[str, Sequence[str], None] = '402a9cfa6b8c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass  # analyses déjà présente, alter_column non supporté par SQLite

def downgrade() -> None:
    pass
