# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : Meridian__RuleBase-members.pm
# Description : 
# Author : yc0325lee
# Created : 2018-12-18 22:59:26 by yc0325lee
# Modified : 2019-01-09 22:59:07 by yc0325lee
# ----------------------------------------------------------------------------

# -------------------------------------
# class methods
sub Meridian__RuleBase::initialize_globals {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) { $class->maxLen($attr,length($attr)); }
}

sub Meridian__RuleBase::write_header {
    @_==1 or confess "[ERR ]";
    my $class = shift;
    confess("[ERR ] Instance method invocated on class method!") if( ref($class) );

    my @attributes = $class->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    foreach my $attr ( @attributes ) {
        printf("%-*s  ", $class->maxLen($attr), $attr);
    }
    printf("\n");
    foreach my $attr ( @attributes ) {
        printf("%-*s  ", $class->maxLen($attr), '-' x $class->maxLen($attr));
    }
    printf("\n");
}


# -------------------------------------
# instance methods
sub Meridian__RuleBase::calcLen {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    my @attributes = $ThisClass->attributes(); # each class's attributes, not __PACKAGE__'s attributes
    return unless( @attributes );
    
    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        foreach my $attr ( @attributes ) {
            my $value = $this->$attr()->[$i];
            if( length($value) > $this->maxLen($attr) ) {
                $this->maxLen($attr,length($value));
            }
        }
    }
}

sub Meridian__RuleBase::write_rpt {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    printf("[INFO] Invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
    my @attributes = $ThisClass->attributes(); # each class's attributes
    return unless( @attributes );

    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        foreach my $attr ( @attributes ) {
            printf("%-*s  ", $this->maxLen($attr), $this->$attr()->[$i]);
        }
        printf("\n");
    }
}

sub Meridian__RuleBase::write_csv {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname

    printf("[INFO] Invoking %s() for %s ...\n", $thisFunction, $ThisClass) if( 0 );
    my @attributes = $ThisClass->attributes(); # each class's attributes
    return unless( @attributes );

    my $firstAttr = $attributes[0];
    for(my $i = 0; $i < @{$this->$firstAttr()}; $i++) {
        my @array;
        foreach my $attr ( @attributes ) {
            push( @array, $this->$attr()->[$i] );
        }
        print join(',', @array), "\n";
    }
}

sub Meridian__RuleBase::print {
    @_==1 or confess "[ERR ]";
    my $this = shift; # blessed-ref
    confess("[ERR ] Class method invocated on instance method!") unless( ref($this) );
    my $thisFunction = (caller(0))[3]; $thisFunction =~ s/.*:://;
    my $ThisClass = ref($this); # $this's classname
    
    my @attributes = $ThisClass->attributes(); # each class's attributes
    print "[INFO] printing ", $this, " ...\n";
}


