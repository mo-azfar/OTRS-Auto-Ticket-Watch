# OTRS-Auto-Ticket-Watch
- For OTRS 6 CE / LTS  
- (add / remove) the current user (to / from) the ticket watchlist when performing *owner and responsible* action based on 2 condition below.  
  
		-- if current user is new owner or new responsible, he will be remove from ticket watchlist  
		-- if current user is not an owner or resposible, he will be add into the ticket watchlist  

- Module disbaled by default. Go to System Configuration and search for  **TicketAutoWatch** and enable it.  
  
- Based on https://forums.otterhub.org/viewtopic.php?f=62&t=42311&sid=a875529b0c6c068c650c29ed881aa8c2  