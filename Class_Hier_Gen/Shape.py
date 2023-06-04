# vim: ft=python ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Shape.py
# Description : 
# Author : yc0325lee
# Created : 2021-06-20 20:08:38 by lee2103
# Modified : 2021-06-20 20:08:38 by lee2103
#
#    Shape__Common => {
#        Shape__Base => {
#            Shape__OneDimensional => {
#                Shape__Dot => {},
#                Shape__Line => {},
#            },
#            Shape__TwoDimensional => {
#                Shape__Circle => {},
#                Shape__Square => {},
#                Shape__Triangle => {},
#            },
#            Shape__ThreeDimensional => {
#                Shape__Sphere => {},
#                Shape__Cube => {},
#                Shape__Tetrahedron => {},
#            },
#        },
#
# ----------------------------------------------------------------------------

# -------------------------------------
# Shape__Base
class Shape__Base:
    count = 0
    def __init__(self, name, color):
        self.name = name
        self.color = color
        Shape__Base.count += 1
    def dump(self):
        print(self)
        print("name=", self.name)
        print("color=", self.color)
    pass

# -------------------------------------
# Shape__OneDimensional
class Shape__OneDimensional(Shape__Base):
    count = 0
    def __init__(self, name, color):
        super().__init__(name, color)
        Shape__OneDimensional.count += 1
    pass

class Shape__Dot(Shape__OneDimensional):
    def __init__(self, name, color, thickness):
        super().__init__(name, color)
        self.thickness = thickness
    def dump(self):
        super().dump()
        print("thickness=", self.thickness, "\n")
    pass

class Shape__Line(Shape__OneDimensional):
    def __init__(self, name, color, length):
        super().__init__(name, color)
        self.length = length
    def dump(self):
        super().dump()
        print("length=", self.length, "\n")
    pass


# -------------------------------------
# Shape__TwoDimensional
class Shape__TwoDimensional(Shape__Base):
    count = 0
    def __init__(self, name, color):
        super().__init__(name, color)
        Shape__TwoDimensional.count += 1
    pass

class Shape__Circle(Shape__TwoDimensional):
    def __init__(self, name, color, radius):
        super().__init__(name, color)
        self.radius = radius
    def dump(self):
        super().dump()
        print("radius=", self.radius, "\n")
    pass

class Shape__Square(Shape__TwoDimensional):
    def __init__(self, name, color, sideLength):
        super().__init__(name, color)
        self.sideLength = sideLength
    def dump(self):
        super().dump()
        print("sideLength=", self.sideLength, "\n")
    pass

class Shape__Triangle(Shape__TwoDimensional):
    def __init__(self, name, color, baseLength, height):
        super().__init__(name, color)
        self.baseLength = baseLength
        self.height = height
    def dump(self):
        super().dump()
        print("baseLength=", self.baseLength)
        print("height=", self.height, "\n")
    pass


# -------------------------------------
# Shape__ThreeDimensional
class Shape__ThreeDimensional(Shape__Base):
    count = 0
    def __init__(self, name, color):
        super().__init__(name, color)
        Shape__ThreeDimensional.count += 1
    pass

class Shape__Sphere(Shape__ThreeDimensional):
    def __init__(self, name, color, radius):
        super().__init__(name, color)
        self.radius = radius
    def dump(self):
        super().dump()
        print("radius=", self.radius, "\n")
    pass

class Shape__Cube(Shape__ThreeDimensional):
    def __init__(self, name, color, edgeLength):
        super().__init__(name, color)
        self.edgeLength = edgeLength
    def dump(self):
        super().dump()
        print("edgeLength=", self.edgeLength, "\n")
    pass

class Shape__Tetrahedron(Shape__ThreeDimensional):
    def __init__(self, name, color, edgeLength):
        super().__init__(name, color)
        self.edgeLength = edgeLength
    def dump(self):
        super().dump()
        print("edgeLength=", self.edgeLength, "\n")
    pass





# -------------------------------------
# main.py
# before
print("Shape__Base.count=", Shape__Base.count)
print("Shape__OneDimensional.count=", Shape__OneDimensional.count)
print("Shape__TwoDimensional.count=", Shape__TwoDimensional.count)
print("Shape__ThreeDimensional.count=", Shape__ThreeDimensional.count)

print("")

shapes = [
    Shape__Dot         ( "dot",         "black", 1 ),
    Shape__Line        ( "line",        "black", 2 ),
    Shape__Circle      ( "circle",      "black", 3 ),
    Shape__Square      ( "square",      "black", 4 ),
    Shape__Triangle    ( "triangle",    "black", 5, 9 ),
    Shape__Sphere      ( "sphere",      "black", 6 ),
    Shape__Cube        ( "cube",        "black", 7 ),
    Shape__Tetrahedron ( "tetrahedron", "black", 8 ),
]

for shape in shapes:
    shape.dump()

print("")

# after
print("Shape__Base.count=", Shape__Base.count)
print("Shape__OneDimensional.count=", Shape__OneDimensional.count)
print("Shape__TwoDimensional.count=", Shape__TwoDimensional.count)
print("Shape__ThreeDimensional.count=", Shape__ThreeDimensional.count)
