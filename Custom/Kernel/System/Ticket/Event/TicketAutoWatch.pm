# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
# (add / remove) the current user (to / from) the ticket watchlist when performing *owner and responsible* action based on 2 condition below.
# - if current user is new owner or new responsible, he will be remove from ticket watchlist
# - if current user is not an owner or resposible, he will be add into the ticket watchlist

package Kernel::System::Ticket::Event::TicketAutoWatch;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	
	# check needed stuff
    for (qw(Data Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
	
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }
	
	# $Param{Data}->{TicketID};  ##This one if using sysconfig ticket event
	# $Param{TicketID};  ##This one if using GenericAgent ticket event

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	
	my %Ticket = $TicketObject->TicketGet(
		TicketID      => $Param{Data}->{TicketID},
		DynamicFields => 0,    
		UserID        => $Param{UserID},
		Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
	);
				
	if ( $Ticket{OwnerID} eq $Param{UserID} || $Ticket{ResponsibleID} eq $Param{UserID} )
	{
		#remove curent user from watchlist as he is now the owner/resposible
		my $Success = $TicketObject->TicketWatchUnsubscribe(
			TicketID    => $Param{Data}->{TicketID},
			WatchUserID => $Param{UserID},
			UserID      => 1,
			);	
	}
	else
	{
		#add current user to watchlist
		my $Success = $TicketObject->TicketWatchSubscribe(
			TicketID    => $Param{Data}->{TicketID},
			WatchUserID => $Param{UserID},
			UserID      => 1,
		);
	}
			
    return 1;
}

1;
