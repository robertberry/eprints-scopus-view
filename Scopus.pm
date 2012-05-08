=head1 NAME

EPrints::Plugin::Screen::Scopus

=cut

package EPrints::Plugin::Screen::Scopus;

use EPrints::Plugin::Screen;

use constant SEARCH_FORM_ID => "sciverse_search_form";
use constant SEARCH_INPUT_ID => "sciverse_search_string";
use constant RESULTS_CONTAINER_ID => "sciverse";
use constant IMPORT_FORM_ID => "sciverse_submit_form";

@ISA = ('EPrints::Plugin::Screen');

use strict;
use warnings;
use autodie;

=head1 METHODS

=cut

sub new {
    my ($class, %params) = @_;

    my $self = $class->SUPER::new(%params);

    $self->{appears} = [
        {
            place => "key_tools",
            position => 101
        }
    ];

    return $self;
}

=head2 can_be_viewed

Returns whether current user can view the page this Plugin renders.

=cut

sub can_be_viewed {
    my $self = shift;

    return $self->allow("create_eprint");
}

=head2 render

Renders the view, returning HTML.

=cut

sub render {
    my $self = shift;

    my ($session, $user, $html);

    $session = $self->{session};
    $user = $session->current_user;
    $html = $session->make_doc_fragment;

    # Set up search form
    {
        my ($search_form, $search_input, $search_submit);

        $search_form = $session->make_element("form",
                                                name => SEARCH_FORM_ID,
                                                id => SEARCH_FORM_ID,
                                                action => "");
        $search_input = $session->make_element("input",
                                                 type => "text",
                                                 name => SEARCH_INPUT_ID);
        $search_submit = $session->make_element("input",
                                                  type => "submit",
                                                  value => "Search");
        $search_form->appendChild($search_input);
        $search_form->appendChild($search_submit);
        $html->appendChild($search_form);

    }

    # Set up results container
    {
        my $results;

        $results = $session->make_element("div",
                                            id => RESULTS_CONTAINER_ID);
        $html->appendChild($results);
    }

    # Set up import form
    {
        my $import_form;

        $import_form = $session->make_element("form",
                                                name => IMPORT_FORM_ID,
                                                id => IMPORT_FORM_ID,
                                                action => "",
                                                method => "POST");
        $html->appendChild($import_form);
    }

    return $html;
}

1;

=head1 COPYRIGHT

=for COPYRIGHT BEGIN

Copyright (c) 2012 The University of Liverpool

=for COPYRIGHT END

=for LICENSE BEGIN

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=for LICENSE END