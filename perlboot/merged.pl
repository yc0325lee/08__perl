# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 00. If we could talk to the animals... - (1)
#   - Nothing spectacular here.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


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


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 01. If we could talk to the animals... - (2)
#   - Symbolic coderef de-referencing used.
#   - This style is not recommended.
#   - This may not work with 'use strict' pragma.
#   - 'no strict ref' pragma is needed!
# ----------------------------------------------------------------------------
#use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


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

print "\n";

# same!
&{"Cow::speak"};
&{"Cow::speak"};
&{"Horse::speak"};
&{"Sheep::speak"};
&{"Sheep::speak"};


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 02. Introducing the method incocation arrow - (1)
#   - Class->method() invokes subroutine method() in package Class.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


sub Cow::speak {
    print "a Cow goes moooo!\n";
}
sub Horse::speak {
    print "a Horse goes neigh!\n";
}
sub Sheep::speak {
    print "a Sheep goes baaaah!\n";
}

Cow->speak(); # Cow::speak("Cow");
Horse->speak(); # Horse::speak("Horse");
Sheep->speak(); # Sheep::speak("Sheep");


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 03. Introducing the method incocation arrow - (2)
#   - The package name has been parted from the subroutine name.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


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

$a->speak(); # Cow::speak("Cow");
$b->speak(); # Horse::speak("Horse");
$c->speak(); # Sheep::speak("Sheep");


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 04. Invoking a barnyard - (1)
#   - It'd be nice if we could factor out the commonality.
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#   - And look at the common codes!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


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


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 05. Invoking a barnyard - (2)
#   - Class->method(@args);
#     ; attempts to invoke subroutine Class::method as follows:
#     ; Class::method("Class", @args);
#     ; First parameter is generally class name.
#   - Re-writed version using above theorem.
#   - Still, there are common codes!
#   - But we can factor out the commonalities more and more.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


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


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 06. Calling a second method to simplify things
#   - Class-name removed from subroutine-name by using 'package'.
#   - Curly braces used for separate name-spaces.
#   - sound() added to factor out the commonalities.
#   - Aha! Now, all classes have same 'speak()' subroutine!
#   - Commonalities on 'speak()' subroutine!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Cow;
    sub sound { return "moooo"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Horse;
    sub sound { return "neigh"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Sheep;
    sub sound { return "baaaah"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 07. Inheriting the windpipes
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
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;                  # ------------------------------------ #
    our @ISA = qw(Animal);        # -> Cow "is a" Animal!                #
    sub sound { return "moooo"; } # Recursive,depth-first,left-to-right! #
}                                 # ------------------------------------ #
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{                                  # ----------------------------------- #
    package Sheep;                 # 3 ways to make @ISA package global! #
    our @ISA = qw(Animal);         # - @Sheep::ISA = qw(Animal);         #
    sub sound { return "baaaah"; } # - our @ISA = qw(Animal);            #
}                                  # - use vars qw(@ISA);                #
                                   # ----------------------------------- #

my @pasture = qw(Cow Cow Horse Sheep Sheep);
foreach my $animal ( @pasture ) {
    $animal->speak();
}

# o flow of method invocation
# Cow->speak();
# Cow::speak("Cow");    -> no definition of 'speak()'!
#                       -> Searches '@ISA' array!
#                       -> 'speak()' found in 'Animal' package!
# Animal::speak("Cow"); -> 'Animal::speak()' is called!


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 08. Overriding the methods - (1)
#   - 'Mouse' added for special handling of speak().
#   - But 'Mouse' was duck-typed because there is no need to have @ISA.
#   - The duplication of code in speak() is not good.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; } # If something or someone squeaks, they make a
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

# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 09. Overriding the methods - (2)
#   - The duplication of code in speak() is not good.
#   - So the Animal::speak() invoked directly.
#   - But invoking Animal::speak() directly is very bad
#     from the point of inheritance mechanism & hard-coded 'Animal'!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
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

# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 10. Overriding the methods - (2)
#   - The duplication of code in speak() is not good.
#   - So the Animal::speak() invoked directly.
#   - But invoking Animal::speak() directly is very bad
#     from the point of inheritance mechanism & hard-coded 'Animal'!
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
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

# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 11. The super way of doing things
#   - 'Animal' was replaced with 'SUPER' keyword!
#   - SUPER::speak means look in the current package's @ISA
#     for a class that implements speak, and invoke the first one found.
#   - Syntax summary
#     Class->method(@args);               |
#     my $a = "Class"; $a->method(@args); | -> Equivalent!
#     Class::method("Class", @args);      |
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
    #   -----------------------> See here!
    #   the contents of Mouse's @ISA are used for the search,
    #   beginning with $ISA[0], $ISA[1], ...
        print "[but you can barely hear it!]\n";
    }
}

my @pasture = qw(Cow Cow Horse Sheep Sheep Mouse);
foreach my $animal ( @pasture ) {
    $animal->speak();
}


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 12. A horse is a horse, of course of course -- or is it?
#   - How do we capture the distinctions of an individual horse?
#   - --> instance data
#   - Any reference can be a instance of class.
#   - bless(REF,CLASSNAME)
#     ; the thingy referenced by REF is now an object in the CLASSNAME package
#     ; returns the 'blessed' reference REF
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
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


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 13. Invoking an instance method
#   - The difference between a class method and an instance method
#     ; Class-method : the first parameter is a class name.
#     ; Instance-method : the first parameter is an instance(blessed reference).
#   - When an instance method is invoked:
#     ; Perl takes the class in which the instance was blessed
#     ; uses that class to locate the subroutine
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
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

my $noise = $horse->sound(); # --> neigh
print "noise : ", $noise, "\n";
print "1. ", $horse->sound(),      "\n"; # instance method invoked!
print "2. ", Horse::sound($horse), "\n"; # Same as above!
print "3. ", Horse->sound(), "\n"; # class method invoked!


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 14. How to build a horse
#   - Introducing constructor.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
}

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->new("Mr.Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 15. Inheritting the constructor and instance method
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->new("Mr.Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";

# But how about calling speak()?
$horse->speak(); # This will be a problem,
                 # a Horse=SCALAR(0xaca42ac) goes neigh!
                 # because speak() is class-only method!
                 # Let's modify speak()!

Mr.Ed says neigh.
a Horse=SCALAR(0x140cc74) goes neigh!
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 16. Inheritting the constructor and instance method
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $this = shift;
        return ${$this};
    }
    sub speak {
        my $class = shift;
        print "a $class goes ", $class->sound(), "!\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

# Constructor! This gives birth to an object(instance).
# The most famous name for constructor is 'new'!
my $horse = Horse->new("Mr.Ed");
print $horse->name(), " says ", $horse->sound(), ".\n";

# But how about calling speak()?
$horse->speak(); # This will be a problem,
                 # a Horse=SCALAR(0xaca42ac) goes neigh!
                 # because speak() is class-only method!
                 # Let's modify speak()!

Mr.Ed says neigh.
a Horse=SCALAR(0x140cc74) goes neigh!
# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 17. Making a method work with either classes or instances
#   - a method to detect if it is being called on a class or called on an
#     instance.
#   - ref(EXPR)
#     ; Returns a non-empty string if EXPR is a reference, the empty string
#       otherwise.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? ${$either} : "Any " . $either;
        #                     ----------            -------
        #                      instance              class
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $horse = Horse->new("Mr.Ed");
print Horse->name(), " says ", $horse->sound(), ".\n";  # "Any Horse"
print $horse->name(), " says ", $horse->sound(), ".\n"; # "Mr.Ed"

$horse->speak(); # Mr.Ed goes neigh


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 18. Adding parameters to a method
#   - Let's train our animals to eat.
#   - An instance method with parameters gets invoked with the instance.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        bless(\$name, $class);
        return \$name; # \$name ---> an object of 'Cow'
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? ${$either} : "Any " . $either;
        #                     ----------            -------
        #                      instance              class
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $horse = Horse->new("Mr.Ed");
$horse->eat("hay");  # -> Animal::eat($horse, "hay");
                     #    Mr. Ed eats hay.
Sheep->eat("grass"); # -> Animal::eat('Sheep', "grass");
                     #    Any Sheep eats grass.


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 19. more interesting instances - (1)
#   - Use blessed hash references to store more instance data.
#   - Overriding new() to handle constructing a sheep with a certain color.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        my $this = { NAME => $name }; # hash reference -> object
        bless($this, $class);
        return $this;
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? $either->{NAME} : "Any " . $either;
        #                     -------                    -------
        #                     instance                    class
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
    sub default_color { return "white"; }
    sub new { # constructor overriding
        my $class = shift;
        my $name = shift;
        my $this = $class->SUPER::new($name);
        #          -------------------------
        #          Animal's constructor is being invoked!

        $this->{COLOR} = $class->default_color(); # new data added!
        return $this;
        # No need to bless($this,$class) cuz this is being done
        # up in the inheritace hierarchy!
    }
    sub color {
        my $this = shift;
        return $this->{COLOR};
    }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $sheep = Sheep->new("Mrs.Jane");
printf("%s's color -> %s\n", $sheep->name(), $sheep->color());


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 20. More interesting instances - (2)
#   - Sheep::new() removed and Animal::new() modified to handle
#     the special case.
#   - Animal::default_color() added to keep from having to define
#     default_color() for each derived class.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub default_color { return "brown"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        my $this = {
            NAME => $name,
            COLOR => $class->default_color(),
        };
        bless($this, $class);
        return $this;
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? $either->{NAME} : "Any " . $either;
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
    sub color {
        my $this = shift;
        return $this->{COLOR};
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
    sub default_color { return "white"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $horse = Horse->new("Mr.Edie"); #
$horse->eat("hay");                # -> Animal::eat($horse, "hay");
print $horse->{COLOR}, "\n";       # brown

Sheep->eat("grass");                # --> Animal::eat('Sheep', "grass");
my $sheep = Sheep->new("Mrs.Jane"); #
print $sheep->{COLOR}, "\n";        # white


# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 21. A horse of a different color
#   - adding methods that get and set the colors.
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;


{
    package Animal;
    sub sound { die "[ERROR] pure virtual function!"; }
    sub new {
        my $class = shift; # class method, so use '$class'!
        my $name = shift;
        my $this = {
            NAME => $name,
            COLOR => $class->default_color(),
        };
        bless($this, $class);
        return $this;
    }
    sub name {
        my $either = shift; # class or instance
        return ref($either) ? $either->{NAME} : "Any " . $either;
    }
    sub speak {
        my $either = shift; # class or instance
        print $either->name(), " goes ", $either->sound(), "\n";
    }
    sub eat {
        my $either = shift;
        my $food = shift;
        print $either->name(), " eats $food.\n";
    }
    sub default_color { return "brown"; }
    sub color { # accessor
        my $this = shift;
        return $this->{COLOR};
    }
    sub set_color { # accessor
        my $this = shift;
        my $color = shift;
        $this->{COLOR} = $color;
    }
}
{
    package Cow;
    our @ISA = qw(Animal);
    sub sound { return "moooo"; }
}
{
    package Horse;
    our @ISA = qw(Animal);
    sub sound { return "neigh"; }
}
{
    package Sheep;
    our @ISA = qw(Animal);
    sub sound { return "baaaah"; }
    sub default_color { return "white"; }
}
{
    package Mouse;
    our @ISA = qw(Animal);
    sub sound { return "squeak"; }
    sub speak {
        my $class = shift;
        $class->SUPER::speak();
        print "[but you can barely hear it!]\n";
    }
}

my $horse = Horse->new("Mr.Edie");
$horse->eat("hay");
print "The color of ", $horse->name(), " : ", $horse->color(), "\n";
$horse->set_color("black-and-white");
printf("(The color was changed.)\n");
print "The color of ", $horse->name(), " : ", $horse->color(), "\n";

Sheep->eat("grass");
my $sheep = Sheep->new("Mrs.Jane");
print "The color of ", $sheep->name(), " : ", $sheep->color(), "\n";


