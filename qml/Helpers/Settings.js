// TSI & Traktor settings import/export
function extractSettingFromTSI(xml, name) {
    const regex = new RegExp(
        `<Entry Name="(?<name>${name.replace(
            /\./g,
            '\\.'
        )})" Type="(?<type>\\d+)" Value="(?<value>[^"]+|)"><\/Entry>$`,
        'gm'
    );
    const result = regex.exec(xml);
    // console.log(result.groups)
    // INFO: Named capturing groups are only supported with JS ECMAScript 2018 and after... So we build our own response
    // console.log(result)
    return result
        ? {
              name,
              type: result[2],
              value: result[3],
          }
        : undefined;
}

function assignTSISetting(xml, name, prop) {
    const setting = extractSettingFromTSI(xml, name);
    if (setting && setting.value != undefined && prop)
        prop.value = setting.value;
    /*
    if (setting && setting.value && prop) {
        console.log(name + ": " + (setting && setting.value ? setting.value : undefined))
    }
    */
}

// JSON & Mod settings import/export
function extractSettingFromJSON(json, path) {
    // Split the path into an array of child names, and then select the settings object at that path
    return path.split('.').reduce((obj, child) => obj && obj[child], json);
}

function assignSetting(settings, path, prop) {
    const setting = extractSettingFromJSON(settings, path);
    if (setting != undefined && prop) prop.value = setting;
    if (setting != undefined && prop) {
        // console.log(path + ": " + setting)
    } else if (!setting) {
        console.log(`Setting ${path} not found in file!`);
    } else {
        console.log(`Property ${prop} not found!`);
    }
}

function exportSettings(path, settings, name = 'settings') {
    console.log('Exporting settings...');
    // console.log("Settings: ", settings)
    // ? A Settings folder is created inside the root folder automatically by Traktor on start-up if it doesn't exist
    const folder = FS.normalizedPath(path).concat('Settings');
    const fileName = `${name}.settings.json`;
    FS.writeFile(folder, fileName, settings, { overwrite: true });
}

function importSettings(path, name = 'settings') {
    console.log('Importing settings...');
    const folder = FS.normalizedPath(path).concat('Settings');
    const fileName = `${name}.settings.json`;
    return FS.open(FS.filePath(folder, fileName))
        .then((settings) => {
            try {
                const parsed = JSON.parse(settings);
                updateModSettings(name, parsed);
            } catch (err) {
                console.error(
                    "Couldn't parse settings. There probably is an error in the file...",
                    err
                );
            }
        })
        .catch((err) => {
            console.error("Couldn't import settings due to an error.", err);
            throw err;
        });
}

function updateModSettings(device, settings, autoAssign = true) {
    assignSetting(settings, 'others.autoimport', autoImport);
    assignSetting(settings, 'others.autoexport', autoExport);

    // ? Prevent auto-assigning if auto-import is disabled when a device is connected
    if (!autoAssign && !autoImport.value) return;

    console.log(`Assigning ${device.toUpperCase()} settings...`);

    // General settings - Hardware
    assignSetting(settings, 'hardware.leds.on_brightness', onBrightness);
    assignSetting(
        settings,
        'hardware.leds.dimmed_brightness',
        dimmedBrightness
    );

    assignSetting(settings, 'hardware.buttons.play.modes.default', playButton);
    assignSetting(
        settings,
        'hardware.buttons.play.modes.shift',
        shiftPlayButton
    );
    assignSetting(settings, 'hardware.buttons.play.blinker', playBlinker);

    assignSetting(settings, 'hardware.buttons.cue.modes.default', cueButton);
    assignSetting(settings, 'hardware.buttons.cue.modes.shift', shiftCueButton);
    assignSetting(settings, 'hardware.buttons.cue.blinker', cueBlinker);

    /*
    assignSetting(settings, "hardware.buttons.sync.modes.default", syncButton)
    assignSetting(settings, "hardware.buttons.sync.modes.shift", shiftSyncButton)
    assignSetting(settings, "hardware.buttons.sync.blinker", syncBlinker)
    */

    assignSetting(
        settings,
        'hardware.encoders.browse.push.shift',
        shiftBrowsePush
    );
    assignSetting(
        settings,
        'hardware.encoders.browse.turn.default',
        browseEncoder
    );
    assignSetting(
        settings,
        'hardware.encoders.browse.turn.shift',
        shiftBrowseEncoder
    );

    assignSetting(settings, 'hardware.faders.fader_start', faderStart);

    assignSetting(
        settings,
        'hardware.pads.slot_selector.mode',
        slotSelectorMode
    );
    assignSetting(settings, 'hardware.pads.hotcues.play_mode', hotcuesPlayMode);
    assignSetting(settings, 'hardware.pads.hotcues.colors', hotcueColors);

    // General settings - Display
    assignSetting(settings, 'display.theme.selected', theme);
    assignSetting(settings, 'display.theme.bright_mode', brightMode);

    assignSetting(
        settings,
        'display.general.key.camelot_key',
        displayCamelotKey
    );
    assignSetting(
        settings,
        'display.general.key.resulting_key',
        displayResultingKey
    );
    assignSetting(settings, 'display.general.key.use_key_text', useKeyText);
    assignSetting(settings, 'display.general.bpm.widget', phaseWidget);
    assignSetting(settings, 'display.general.bpm.beats_x_phrase', beatsxPhrase);
    assignSetting(
        settings,
        'display.general.bpm.counter_mode',
        beatCounterMode
    );

    assignSetting(
        settings,
        'display.panels.top_panel_on_touch',
        showTopPanelOnTouch
    );
    assignSetting(
        settings,
        'display.panels.bottom_panel_on_touch',
        showBottomPanelOnTouch
    );
    assignSetting(
        settings,
        'display.panels.show_assigned_fx_overlays',
        showAssignedFXOverlays
    );

    assignSetting(
        settings,
        'display.browser.behavior.browse_on_touch',
        showBrowserOnTouch
    );
    assignSetting(
        settings,
        'display.browser.behavior.related_browsers',
        traktorRelatedBrowser
    );
    assignSetting(settings, 'display.browser.appearance.rows', browserRows);
    assignSetting(
        settings,
        'display.browser.appearance.previously_played_tracks',
        showTracksPlayedDarker
    );
    assignSetting(
        settings,
        'display.browser.appearance.info.album',
        browserAlbum
    );
    assignSetting(
        settings,
        'display.browser.appearance.info.artist',
        browserArtist
    );
    assignSetting(settings, 'display.browser.appearance.info.bpm', browserBPM);
    assignSetting(settings, 'display.browser.appearance.info.key', browserKey);
    assignSetting(
        settings,
        'display.browser.appearance.info.rating',
        browserRating
    );
    assignSetting(
        settings,
        'display.browser.appearance.colored_keys',
        keyColorsInBrowser
    );
    assignSetting(
        settings,
        'display.browser.appearance.footer',
        browserFooterInfo
    );

    assignSetting(settings, 'display.deck.top_left_corner', topLeftCorner);
    assignSetting(settings, 'display.deck.waveform.color', waveformColor);
    assignSetting(settings, 'display.deck.waveform.dynamic', dynamicWF);
    assignSetting(settings, 'display.deck.waveform.offset', waveformOffset);
    assignSetting(settings, 'display.deck.waveform.grid.mode', gridMode);
    assignSetting(
        settings,
        'display.deck.waveform.grid.markers',
        displayGridMarkersWF
    );
    assignSetting(
        settings,
        'display.deck.waveform.grid.phrases',
        displayPhrasesWF
    );
    assignSetting(settings, 'display.deck.waveform.grid.bars', displayBarsWF);
    assignSetting(
        settings,
        'display.deck.stripe.played_darker',
        displayDarkenerPlayed
    );
    assignSetting(
        settings,
        'display.deck.stripe.deck_indicator',
        displayDeckLetterStripe
    );

    assignSetting(
        settings,
        'display.deck.remix.volume_fader',
        showVolumeFaders
    );
    assignSetting(
        settings,
        'display.deck.remix.filter_fader',
        showFilterFaders
    );
    assignSetting(
        settings,
        'display.deck.remix.slot_indicators',
        showSlotIndicators
    );

    // General settings - Others
    assignSetting(settings, 'others.hardware.global_shift', globalShift);
    assignSetting(
        settings,
        'others.hardware.vinyl_break.in_beats',
        vinylBreakInBeats
    );
    assignSetting(
        settings,
        'others.hardware.vinyl_break.duration.in_beats',
        vinylBreakDurationInBeats
    );
    assignSetting(
        settings,
        'others.hardware.vinyl_break.duration.in_seconds',
        vinylBreakDurationInSeconds
    );
    assignSetting(settings, 'others.hardware.key_sync.fuzzy', fuzzyKeySync);
    assignSetting(
        settings,
        'others.hardware.key_sync.use_key_text',
        useKeyText
    );

    assignSetting(settings, 'others.timers.browser', browserTimer);
    assignSetting(settings, 'others.timers.overlays.general', overlayTimer);
    assignSetting(
        settings,
        'others.timers.overlays.hotcue_type',
        hotcueTypeTimer
    );

    assignSetting(settings, 'others.fixes.bpm_controls', fixBPMControl);
    assignSetting(settings, 'others.fixes.hotcue_triggering', fixHotcueTrigger);

    assignSetting(
        settings,
        'others.mods.only_focused_controls',
        onlyFocusedDeck
    );
    assignSetting(
        settings,
        'others.mods.beatmatch_practice_mode',
        beatmatchPracticeMode
    );
    assignSetting(
        settings,
        'others.mods.autoenable_flux_on_looproll',
        enableFluxOnLoopRoll
    );
    assignSetting(
        settings,
        'others.mods.autozoom_on_edit_mode',
        autoZoomTPwaveform
    );

    // Common device-specific settings
    // ? Legacy devices
    if (device == 's5' || device == 's8' || device == 'd2') {
        assignSetting(
            settings,
            'hardware.touchstrip.bend_nudge.sensivity',
            bendSensitivity
        );
        assignSetting(
            settings,
            'hardware.touchstrip.bend_nudge.direction',
            bendDirection
        );
        assignSetting(
            settings,
            'hardware.touchstrip.scratch.sensivity',
            scratchSensitivity
        );
        assignSetting(
            settings,
            'hardware.touchstrip.scratch.direction',
            scratchDirection
        );

        assignSetting(
            settings,
            'hardware.encoders.browse.bpm_steps.default',
            stepBpm
        );
        assignSetting(
            settings,
            'hardware.encoders.browse.bpm_steps.shift',
            stepShiftBpm
        );
        assignSetting(
            settings,
            'hardware.encoders.browse.tempo_steps.default',
            stepTempo
        );
        assignSetting(
            settings,
            'hardware.encoders.browse.tempo_steps.shift_step',
            stepShiftTempo
        );

        assignSetting(
            settings,
            'display.panels.hide_bottom_panel',
            hideBottomPanel
        );
        assignSetting(settings, 'display.panels.performance_pads', panelMode);
        assignSetting(
            settings,
            'display.deck.waveform.loop_size_overlay',
            showLoopSizeOverlay
        );

        assignSetting(settings, 'display.theme.supreme.active', displayActive);

        assignSetting(
            settings,
            'others.timers.overlays.mixer_fx',
            mixerFXTimer
        );
        assignSetting(
            settings,
            'others.timers.overlays.side_buttons',
            sideButtonsTimer
        );
    }
    // ? S8 & D2
    if (device == 's8' || device == 'd2') {
        assignSetting(
            settings,
            'hardware.buttons.loop.modes.default',
            loopButton
        );
        assignSetting(
            settings,
            'hardware.buttons.loop.modes.shift',
            shiftLoopButton
        );

        assignSetting(
            settings,
            'hardware.buttons.freeze.modes.default',
            freezeButton
        );
        assignSetting(
            settings,
            'hardware.buttons.freeze.modes.shift',
            shiftFreezeButton
        );

        assignSetting(
            settings,
            'hardware.buttons.fx_select.modes.default',
            fxSelectButton
        );
        assignSetting(
            settings,
            'hardware.buttons.fx_select.modes.shift',
            shiftFxSelectButton
        );

        assignSetting(
            settings,
            'others.hardware.midi_settings.use_midi',
            useMIDIControls
        );
    }

    // Device-specific settings
    switch (device) {
        case 's5':
            assignSetting(
                settings,
                'hardware.buttons.hotcue.modes.shift',
                shiftCueButton
            );

            assignSetting(
                settings,
                'hardware.encoders.loop.push.default',
                loopEncoderInBrowser
            );
            assignSetting(
                settings,
                'hardware.encoders.loop.push.shift',
                shiftLoopEncoderInBrowser
            );

            assignSetting(
                settings,
                'others.hardware.stem_controls.reset_on_load',
                stemResetOnLoad
            );
            break;
        case 's8':
            break;
        case 'd2':
            assignSetting(
                settings,
                'hardware.buttons.d2_buttons.modes.default',
                d2buttons
            );
            break;
        case 's4mk3':
            // Traktor settings
            assignSetting(settings, 'hardware.jogwheels.base_speed', baseSpeed);
            assignSetting(
                settings,
                'hardware.jogwheels.tension',
                jogwheelTension
            );
            assignSetting(
                settings,
                'hardware.jogwheels.haptic_feedback.ticks_on_nudging',
                ticksOnNudging
            );
            assignSetting(
                settings,
                'hardware.jogwheels.haptic_feedback.hotcues',
                hapticHotcues
            );

            assignSetting(
                settings,
                'hardware.faders.relative_tempo_faders',
                relativeTempoFaders
            );

            // Custom settings
            assignSetting(
                settings,
                'hardware.buttons.hotcue.modes.shift',
                shiftCueButton
            );

            assignSetting(
                settings,
                'hardware.buttons.stems.modes.default',
                stemsButton
            );
            assignSetting(
                settings,
                'hardware.buttons.stems.modes.shift',
                shiftStemsButton
            );

            assignSetting(
                settings,
                'hardware.buttons.sync.modes.shift',
                shiftSyncButton
            );

            assignSetting(
                settings,
                'hardware.encoders.loop_size.push.shift',
                shiftPushLoopSize
            );

            assignSetting(
                settings,
                'display.browser.behavior.in_screen_navigation',
                browserInScreens
            );
            break;
        default:
            throw new Error(
                'The device we are trying to import settings for is not supported...'
            );
    }
}
