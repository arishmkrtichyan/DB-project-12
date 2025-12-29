from sqlalchemy import Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import relationship
from src.db.database import Base


class Enterprise(Base):
    __tablename__ = "enterprise"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    activity_type = Column(String)
    employees_count = Column(Integer)

    supplies = relationship("Supply", back_populates="enterprise")


class Product(Base):
    __tablename__ = "product"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    purchase_price = Column(Integer)

    supplies = relationship("Supply", back_populates="product")


class Supply(Base):
    __tablename__ = "supply"

    id = Column(Integer, primary_key=True)
    enterprise_id = Column(Integer, ForeignKey("enterprise.id"))
    product_id = Column(Integer, ForeignKey("product.id"))
    quantity = Column(Integer)
    supply_date = Column(Date)

    enterprise = relationship("Enterprise", back_populates="supplies")
    product = relationship("Product", back_populates="supplies")
