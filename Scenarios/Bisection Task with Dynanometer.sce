# -------------------------- Header Parameters --------------------------

scenario = "Bisection Task"; 

#write_codes = EXPARAM( "Send ERP Codes" );

max_y = 100;
active_buttons = 2;
button_codes= 1, 2;
response_matching = simple_matching;
event_code_delimiter = ";";
no_logfile = false;
response_logging = log_active;
write_codes = true;
response_port_output = false;

stimulus_properties =
	event_cond, string,
	subject_id, number,
	block_name, string,
	block_number, number,
	trial_number, number,	
	probe, number,
	ITI, number;

# ------------------------------- SDL Part ------------------------------
begin;


#Set default picture so can make it white later in PCL
picture {} default;

# ----------------------------- Stimuli -----------------------------
array {
   sound { wavefile { filename = "1000.wav"; preload = false; }; };
   sound { wavefile { filename = "1200.wav"; preload = false; }; };
   sound { wavefile { filename = "1441.wav"; preload = false; }; };
	sound { wavefile { filename = "1730.wav"; preload = false; }; };
	sound { wavefile { filename = "2077.wav"; preload = false; }; };
	sound { wavefile { filename = "2493.wav"; preload = false; }; };
	sound { wavefile { filename = "2993.wav"; preload = false; }; };
} sounds;



# ------------------------------- Trials ------------------------------
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1; # only SPACE
	
	stimulus_event{
		picture { 
			text { 
				caption = " "; 
				preload = false;
				font_size = 4.5;
			} instruct_text; 
			x = 0; 
			y = 0;
		};
		port_code = 3;
		code = "Instruction";
	} instruct_event;
} instruct_trial; # for practice instr and test instr, manually replace caption

trial {
	clear_active_stimuli = false;
	monitor_sounds = false; # sounds are not terminated if a trial ends
	all_responses = false; # response during stimuli presentation is disabled
	
	stimulus_event {
		sound { 
			wavefile { 
				filename = ""; 
				preload = false; 
			}; 
		} sound_anchors;
		code = "";	
	} sound_event;	
	
	stimulus_event { 
		picture {
			text { 
				caption = "";
				preload = false; 
				font_size = 6;
			} anchor_text;
			x = 0;
			y = 0;
		} label_anchors;
	} sound_label_event;
} sound_trial; 

trial {
	stimulus_event {
			picture{};
	code = "ITI";
	} ITI_event;
}ITI_trial;

trial { 
   trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1, 2; # press SPACE to end break, R to repeat
	
	stimulus_event {
		picture {
			text {
				caption = "";
				preload = false; 
				font_size = 6;
				} end_block_text;
			x = 0; 
			y = 0;
		} end_block_pic;
		code = "End_Block";
	} end_block_event;
} end_block_trial;

trial {	
	stimulus_event {
		picture { 
			text { 
				caption = "";
				preload = false;
				font_size = 6; 
			} fb_text; 
			x = 0; 
			y = 0; 
		}fb_pic;
		code = "Feedback";
	} feedback_event;
} fb_trial;

trial{
	trial_type = specific_response;
	terminator_button = 1;
	trial_duration = forever;
	stimulus_event {
		picture {
			text {
				caption = " ";
				preload = false;
				font_size = 30;
			}caption_1;
			x = 0; y =0;
			text {
				caption = "(Press SPACE to move on)";
				font_size = 5;
			}caption_2;
			x = 0; y = -85;
		} break_pic;
		code = "Break";
	}break_event;
} break_trial;

picture {
   text { 
	caption = "Enter participant number:"; 
	font_size = 5	;
};
   x = 0; y = 0;
   text { caption = " "; font_size = 2;} parti_num_text;
   x = 0; y = -20;
} parti_num;

# ----------------------------- PCL Program -----------------------------
begin_pcl;

#CONSTANTS
int SHORT_port;
int LONG_port;
string Dynanometer_Position;
int ONE_SEC = 1000;

# ----------------------------- Functions -----------------------------

include_once "..\\PCLs\\Import_Functions.pcl";

# ----------------------------- Participant Number -----------------------------

include_once "..\\PCLs\\Participant Number.pcl";

# ----------------------------- Import Message File -----------------------------
language_file lang = new language_file;
lang.load( stimulus_directory + "English.xml" );


# ----------------------------- Study Block -----------------------------

play_instruct_trial( lang.get_text( "Instructions" ) );
include_once "..\\PCLs\\Study_Block.pcl";
anchor_text.set_caption( "" ); #reset caption since in practice phase we don't show caption along with stimuli
play_break_trial( "BREAK" );
play_ITI_trial( ONE_SEC ); #Just a short blank screen between blocks

# ----------------------------- PRACTICE Block -----------------------------

play_instruct_trial( lang.get_text( Dynanometer_Position ) );
include_once "..\\PCLs\\Practice_Block.pcl";
play_break_trial( "BREAK" );
play_instruct_trial( lang.get_text("Practice Complete Caption" ) );
play_ITI_trial( ONE_SEC ); #Just a short blank screen between blocks


# ----------------------------- TEST Block -----------------------------

include_once "..\\PCLs\\Test_Block.pcl";

# ----------------------------- END -----------------------------
play_instruct_trial( lang.get_text( "Completion Screen Caption" ) );
