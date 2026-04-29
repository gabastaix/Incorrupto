"""add cleaned_content to articles

Revision ID: 402a9cfa6b8c
Revises: e71de9e9ea0e
Create Date: 2026-04-29 17:50:34.643956

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '402a9cfa6b8c'
down_revision: Union[str, Sequence[str], None] = 'e71de9e9ea0e'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass  # cleaned_content déjà présente en BDD

def downgrade() -> None:
    pass
