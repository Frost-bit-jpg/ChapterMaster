function scr_battle_count(){
	// Ensure the global variable exists (safety check)
    if (!variable_global_exists("enemies_cleared_count")) {
        log_error("Global variable 'enemies_cleared_count' not found in check_purge_milestone!");
        exit; // Exit the function if the counter doesn't exist
    }

    // Check if the count is positive and a multiple of 4
    if (global.enemies_cleared_count > 0 && (global.enemies_cleared_count mod 4 == 0)) {

        // --- ACTION TO PERFORM EVERY 4 CLEARS ---

        // --- Randomly Choose Flavor Text ---
        var _num_options = 5; // <<< SET THIS to the number of text options below
        var _text_choice = irandom(_num_options - 1); // Generates a random integer from 0 to (_num_options - 1)

        // Use a switch statement for cleaner selection
        switch (_text_choice) {

            case 0: // Option 1 (Influential Ears)
                scr_alert("blue", "reward", "Word of your Chapter's tireless defence of the Sector reaches influential ears within the Imperium.", 0, 0);
                scr_event_log("INFO", "Imperial Factions note the Chapter's continued effectiveness in purging threats.");
                break;

            case 1: // Option 2 (Efficiency Not Unnoticed)
                scr_alert("blue", "reward", "The efficiency of your recent purges has not gone unnoticed. Certain Imperial factions mark your Chapter's progress.", 0, 0);
                scr_event_log("INFO", "Imperial elements acknowledge the Chapter's effectiveness against sector threats.");
                break;

            case 2: // Option 3 (Bureaucratic Acknowledgment)
                scr_alert("blue", "reward", "Data-slate communiques confirm receipt of your operational summaries. Standard commendations issued.", 0, 0);
                scr_event_log("INFO", "Administratum logs successful anti-xenos/heretic operations by the Chapter.");
                break;

            case 3: // Option 4 (Faith and Fury)
                scr_alert("blue", "reward", "Your Chapter's righteous fury against the enemies of Man strengthens the faith of nearby Imperial worlds.", 0, 0);
                scr_event_log("INFO", "Tales of the Chapter's victories inspire piety and bolster relations with the faithful.");
                break;

            case 4: // Option 5 (Simple Effectiveness)
                scr_alert("blue", "reward", "Reports highlight your Chapter's capability in neutralizing sector threats. Imperial support elements take note.", 0, 0);
                scr_event_log("INFO", "Chapter operations demonstrably reduce enemy presence; Imperial factions approve.");
                break;

            // Add more cases here if you create more text options
            // case 5:
            //     scr_alert(...);
            //     scr_event_log(...);
            //     break;

            default: // Fallback in case something goes wrong
                scr_alert("blue", "reward", "Your Chapter continues its duties effectively.", 0, 0);
                scr_event_log("INFO", "Chapter effectiveness noted by Imperial factions.");
                break;
        }
        // --- End Flavor Text Selection ---


        // --- Apply disposition bonuses (without clamping - as requested previously) ---
        if (instance_exists(obj_controller)) {
             obj_controller.disposition[eFACTION.Imperium] += 8;
             obj_controller.disposition[eFACTION.Mechanicus] += 5;
             obj_controller.disposition[eFACTION.Ecclesiarchy] += 6;
             obj_controller.disposition[eFACTION.Inquisition] += 4;
        } else {
             log_error("obj_controller not found in check_purge_milestone!");
        }
        // --- END ACTION TO PERFORM ---
    }
}
