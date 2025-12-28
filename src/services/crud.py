from sqlalchemy.orm import Session
from src.models.models import Enterprise, Product, Supply


def create_enterprise(db: Session, name: str, activity_type: str, employees_count: int):
    enterprise = Enterprise(
        name=name,
        activity_type=activity_type,
        employees_count=employees_count
    )
    db.add(enterprise)
    db.commit()
    db.refresh(enterprise)
    return enterprise
