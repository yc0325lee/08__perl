# ----------------------------------------------------------------------------
# IF WE COULD TALK TO THE ANIMALS... - (1)
#   - Nothing spectacular here.
# ----------------------------------------------------------------------------
sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}
Cow::speak();
Horse::speak();
Sheep::speak();


# ----------------------------------------------------------------------------
# IF WE COULD TALK TO THE ANIMALS... - (2)
#   - Symbolic coderef de-referencing used.
#   - This style is not recommended.
#   - This may not work with 'use strict' pragma.
#   - 'no strict ref' pragma is needed!
# ----------------------------------------------------------------------------
sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

# Pasture is land with grass growing on it for farm animals to eat.
my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    &{ $animal . "::speak" };
    #  -------------------
    #   |
    # This is a string!
}


# ----------------------------------------------------------------------------
# INTRODUCING THE METHOD INCOCATION ARROW - (1)
#   - Class->method() invokes subroutine method() in package Class.
# ----------------------------------------------------------------------------
sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

Cow->speak();
Horse->speak();
Sheep->speak();


# ----------------------------------------------------------------------------
# INTRODUCING THE METHOD INCOCATION ARROW - (2)
#   - The package name has been parted from the subroutine name.
# ----------------------------------------------------------------------------
sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

my $a = 'Cow';
my $b = 'Horse';
my $c = 'Sheep';

$a->speak();
$b->speak();
$c->speak();


# ----------------------------------------------------------------------------
# INVOKING A BARNYARD - (1)
#   - It'd be nice if we could factor out the commonality.
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#   - And look at the common codes!
# ----------------------------------------------------------------------------
sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# INVOKING A BARNYARD - (2)
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#     ; First parameter is generally class name.
#   - Re-writed version using above theorem.
#   - Still, there are common codes!
#   - But we can factor out the commonalities more and more.
# ----------------------------------------------------------------------------
sub Cow::speak {
    my $class = shift;
    print "a $class goes moooo!\n";
}
sub Horse::speak {
    my $class = shift;
    print "a $class goes neigh!\n";
}
sub Sheep::speak {
    my $class = shift;
    print "a $class goes baaaah!\n";
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# CALLING A SECOND METHOD TO SIMPLIFY THINGS
#   - Class-name removed from subroutine-name by using 'package'.
#   - Curly braces used for separate name-spaces.
#   - sound() added to factor out the commonalities.
#   - Aha! Now, all classes have same 'speak()' subroutine!
#   - Commonalities on 'speak()' subroutine!
# ----------------------------------------------------------------------------
{
    package Cow;
    sub sound { "moooo" }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Horse;
    sub sound { "neigh" }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Sheep;
    sub sound { "baaaah" }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# INHERITING THE WINDPIPES
#   - Definition of common subroutine package called 'Animal' added.
#   - Can share common 'speak()' through 'inheritance'!
#   - '@ISA' needed for inheritance.
#   - '@ISA' must be package-global in each class.
#   - recursive, depth-first, left-to-right search in each @ISA
#   - How to declare '@ISA'
#     ; @Cow::ISA = qw(Animal);
#     ; our @ISA = qw(Animal);
#     ; use vars qw(@ISA); @ISA = qw(Animal);
#     ; use base qw(Animal);
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;             # ------------------------------------ #
    @ISA = qw(Animal);       # -> Cow "is a" Animal!                #
    sub sound { "moooo" }    # Recursive,depth-first,left-to-right! #
}                            # ------------------------------------ #
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{                            # ----------------------------------- #
    package Sheep;           # 3 ways to make @ISA package global! #
    @ISA = qw(Animal);       # - @Sheep::ISA = qw(Animal);         #
    sub sound { "baaaah" }   # - our @ISA = qw(Animal);            #
}                            # - use vars qw(@ISA);                #
                             # ----------------------------------- #
my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}

# Cow->speak();
# Cow::speak("Cow");    -> no definition of 'speak()'!
#                       -> Searches '@ISA' array!
#                       -> 'speak()' found in 'Animal' package!
# Animal::speak("Cow"); -> 'Animal::speak()' is called!


# ----------------------------------------------------------------------------
# OVERRIDING THE METHODS - (1)
#   - 'Mouse' added for special handling of speak().
#   - But 'Mouse' was duck-typed because there is no need to have @ISA.
#   - The duplication of code in speak() is not good.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }    # If something or someone squeaks, they make a
                              # short, high-pitched sound.

                              # This package has speak() subroutine!
    sub speak {               # speak() -> overriden!
        my $class = shift;    # There is still commonality!
        print "a $class goes ", $class->sound, "!\n";
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# OVERRIDING THE METHODS - (2)
#   - The duplication of code in speak() is not good.
#   - So the Animal::speak() invoked directly.
#   - But invoking Animal::speak() directly is very bad
#     from the point of inheritance mechanism & hard-coded 'Animal'!
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }
    sub speak {
        my $class = shift;
        Animal::speak($class);
    #   -------------> Invoked directly!
        print "[but you can barely hear it!]\n";
    }
    # This is fragile and leaky because:
    # 1) What if there is no 'speak()' in Animal class
    #    ('Animal' inherited from some other class!)
    # 2) Hard-coded 'Animal'!
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# STARTING THE SEARCH FROM A DIFFERENT PLACE
#   - ClassName->FirstPlaceToLook::method()
#   - By invoking '$class->Animal::speak()' we solved the inheritance
#     problem.
#   - But still 'Animal' hard-coded!
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }
    sub speak {
        my $class = shift;
        $class->Animal::speak();
    #   -----------------------> See here!
    #   Start with 'Animal' to find speak()!
    #   Use 'Animal' inheritance chain if not found there!
    #   Still, 'Animal' hard-coded!
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# THE SUPER WAY OF DOING THINGS
#   - 'Animal' was replaced with 'SUPER' keyword!
#   - SUPER::speak means look in the current package's @ISA
#     for a class that implements speak, and invoke the first one found.
#   - Syntax summary
#     Class->method(@args);               |
#     my $a = "Class"; $a->method(@args); | -> Equivalent!
#     Class::method("Class", @args);      |
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
    #   ---------------------- See here!
    #   the contents of Mouse's @ISA are used for the search,
    #   beginning with $ISA[0], $ISA[1], ...
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# ----------------------------------------------------------------------------
# A HORSE IS A HORSE, OF COURSE OF COURSE -- OR IS IT?
#   - How do we capture the distinctions of an individual horse?
#   - --> instance data
#   - Any reference can be a instance of class.
#   - bless(REF,CLASSNAME)
#     ; the thingy referenced by REF is now an object in the CLASSNAME package
#     ; returns the blessed reference REF
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $name = "Mr.Ed";
my $horse = \$name;     # Reference to $name
bless($horse, 'Horse'); # Now, $horse is blessed reference!
                        # That is, an instance of Horse!
print "The content of \$horse : ", ${$horse}, "\n"; # Mr.Ed
print "ref(\$horse) : ", ref($horse), "\n";


# ----------------------------------------------------------------------------
# INVOKING AN INSTANCE METHOD
#   - The difference between a class method and an instance method
#     ; Class-method : the first parameter is a class name.
#     ; Instance-method : the first parameter is an instance(blessed reference).
#   - When an instance method is invoked:
#     ; Perl takes the class in which the instance was blessed
#     ; uses that class to locate the subroutine
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    @ISA = qw(Animal);
    sub sound { "moooo" }
}
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
{
    package Mouse;
    @ISA = qw(Animal);
    sub sound { "squeak" }
    sub speak {
        my $class = shift;
        $class->SUPER::speak(); # See here!
        print "[but you can barely hear it!]\n";
    }
}

my $name = "Mr.Ed";
my $horse = \$name;
bless($horse, 'Horse');

print "The content of \$horse : ", ${$horse}, "\n";
print "ref(\$horse) : ", ref($horse), "\n";
my $noise = $horse->sound(); # --> neigh
print "noise : ", $noise, "\n";
print "1. ", $horse->sound(),      "\n"; # instance method invoked!
print "2. ", Horse::sound($horse), "\n"; # Same as above!


# ----------------------------------------------------------------------------
# ACCESSING THE INSTANCE DATA
#   - It's traditional to shift the first parameter into a variable named
#   $self for instance methods and into a variable named $class for class
#   methods.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
    sub name {
        $self = shift; # See here!
        return ${$self};
    }
}
# package Sheep;
# package Mouse;

my $name = "Mr.Ed";
my $horse = \$name;
bless($horse, 'Horse');
print $horse->name(), " says ", $horse->sound(), ".\n";
# -> Mr. Ed says neigh.


# ----------------------------------------------------------------------------
# HOW TO BUILD A HORSE
#   - Introducing constructor.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
    sub name {
        $self = shift;  # instance method, so use '$self'!
        return ${$self};
    }
    sub named {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless \$name, $class;
        #--------------------- returns '\$name'!
    }
}
# package Sheep;
# package Mouse;

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->named("Mr. Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";


# ----------------------------------------------------------------------------
# INHERITING THE CONSTRUCTOR
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
    sub name {
        $self = shift;
        return ${$self};
    }
    sub named {                # constructor
        my $class = shift;
        my $name = shift;
        bless \$name, $class;
        return \$name;
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
# package Mouse;

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->named("Mr. Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";

# But how about calling speak()?
$horse->speak(); # This will be a problem,
                 # a Horse=SCALAR(0xaca42ac) goes neigh!
                 # because speak() is class-only method!
                 # Let's modify speak()!


# ----------------------------------------------------------------------------
# MAKING A METHOD WORK WITH EITHER CLASSES OR INSTANCES
#   - a method to detect if it is being called on a class or called on an
#     instance.
#   - ref(EXPR)
#     ; Returns a non-empty string if EXPR is a reference, the empty string
#       otherwise.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub speak {
        my $either = shift; # class or instance!
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub name {
        my $either = shift; # class or instance!
        return
            ref($either) ? ${$either} : "Any $either";
        #                  ----------   -------------
        #                   instance        class
    }
    sub named {
        my $class = shift;
        my $name = shift;
        bless \$name, $class;
        return \$name;
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
# package Mouse;

my $horse = Horse->named("Mr. Ed");
print Horse->name(), " says ", $horse->sound(), ".\n";  # "Any Horse"
print $horse->name(), " says ", $horse->sound(), ".\n"; # "Mr. Ed"

$horse->speak(); # Mr. Ed goes neigh


# ----------------------------------------------------------------------------
# ADDING PARAMETERS TO A METHOD
#   - Let's train our animals to eat.
#   - An instance method with parameters gets invoked with the instance.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub named { # Constructor! Class-only method!
        my $class = shift;
        my $name = shift;
        bless \$name, $class;
    }
    sub name {
        my $either = shift; # class or instance!
        return
            ref($either) ? ${$either} : "Any $either";
    }
    sub speak {
        my $either = shift; # class or instance!
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
}
# package Mouse;

my $horse = Horse->named("Mr. Ed");
$horse->eat("hay");  # -> Animal::eat($horse, "hay");
                     #    Mr. Ed eats hay.
Sheep->eat("grass"); # -> Animal::eat('Sheep', "grass");
                     #    Any Sheep eats grass.


# ----------------------------------------------------------------------------
# MORE INTERESTING INSTANCES - (1)
#   - Use blessed hash references to store more instance data.
#   - Overriding named() to handle constructing a sheep
#     with a certain color.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub named { # Constructor! Class-only method!
        my $class = shift;
        my $name = shift;
        my $self = { Name => $name }; # reference to anonymous hash!
        bless $self, $class;
        return $self;
    }
    sub name {
        my $either = shift; # class or instance!
        return
            ref($either) ? $either->{Name} : "Any $either";
    }
    sub speak {
        my $either = shift; # class or instance!
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
    sub default_color { "White" };
    sub named { # Constructor overridden!
        my $class = shift;
        my $name = shift;
        my $self = $class->SUPER::named($name);
        #          ---------------------------
        #          Animal's constructor is being re-used!
        $self->{'Color'} = $class->default_color();
        return $self;
    }
}
# package Mouse;

my $horse = Horse->named("Mr. Ed");
$horse->eat("hay");  # --> Animal::eat($horse, "hay");
Sheep->eat("grass"); # --> Animal::eat('Sheep', "grass");


# ----------------------------------------------------------------------------
# MORE INTERESTING INSTANCES - (2)
#   - Sheep::named() removed and Animal::named() modified to handle
#       the special case.
#   - Animal::default_color() added to keep from having to define
#       default_color() for each derived class.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub named { # Constructor! Class-only method!
        my $class = shift;
        my $name = shift;
        my $self = {
            Name => $name,
            Color => $class->default_color(),
        };
        bless $self, $class;
        return $self;
    }
    sub default_color { "brown" };
    sub name {
        my $either = shift; # class or instance!
        return
            ref($either) ? $either->{Name} : "Any $either";
    }
    sub speak {
        my $either = shift; # class or instance!
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
    sub default_color { "white" }; # specific to 'Sheep'!
}
# package Mouse;

my $horse = Horse->named("Mr. Ed"); #
$horse->eat("hay");                 # -> Animal::eat($horse, "hay");
print $horse->{Color}, "\n";        # brown

Sheep->eat("grass");             # --> Animal::eat('Sheep', "grass");
my $sheep = Sheep->named("Bad"); #
print $sheep->{Color}, "\n";     # white


# ----------------------------------------------------------------------------
# A HORSE OF A DIFFERENT COLOR
#   - Adding methods that get and set the colors.
# ----------------------------------------------------------------------------
{
    package Animal;
    sub named { # Constructor! Class-only method!
        my $class = shift;
        my $name = shift;
        my $self = {
            Name => $name,
            Color => $class->default_color(),
        };
        bless $self, $class; # returns reference!
        return $self;
    }
    sub name {
        my $either = shift; # class or instance!
        return
            ref($either) ? $either->{Name} : "Any $either";
    }
    sub speak {
        my $either = shift; # class or instance!
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
    sub default_color { "brown" };
    sub color {         # accessor
                        # instance-method
        $_[0]->{Color}; # returns color!
    }
    sub set_color {             # accessor
                                # instance-method
        $_[0]->{Color} = $_[1]; # sets the color!
    }
}
# package Cow;
{
    package Horse;
    @ISA = qw(Animal);
    sub sound { "neigh" }
}
# package Sheep;
{
    package Sheep;
    @ISA = qw(Animal);
    sub sound { "baaaah" }
    sub default_color { "white" };
}
# package Mouse;

my $horse = Horse->named("Mr. Ed");
$horse->eat("hay");
print $horse->name(), " is colored ", $horse->color(), "!\n";
$horse->set_color("black-and-white");
print $horse->name(), " is colored ", $horse->color(), "!\n";
# -> Mr. Ed is colored black-and-white!

Sheep->eat("grass");
my $sheep = Sheep->named("Bad-sheep");
print $sheep->name(), " is colored ", $sheep->color(), "!\n";
# -> Bad-sheep is colored white!


