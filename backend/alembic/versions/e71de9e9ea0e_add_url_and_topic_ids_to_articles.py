"""add url and topic_ids to articles

Revision ID: e71de9e9ea0e
Revises: 84c3cb6b8cca
Create Date: 2026-04-28 18:52:54.735080

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e71de9e9ea0e'
down_revision: Union[str, Sequence[str], None] = '84c3cb6b8cca'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

def upgrade() -> None:
    pass  # colonnes déjà présentes en BDD

def downgrade() -> None:
    pass
