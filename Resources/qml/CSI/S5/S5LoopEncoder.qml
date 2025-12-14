import CSI 1.0

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    // Ensure deckId is always valid (1-4) to prevent invalid AppProperty paths
    property int safeDeckId: (deckId >= 1 && deckId <= 4) ? deckId : 1

    AppProperty { id: browserSortId; path: "app.traktor.browser.sort_id" }

    property string deckPath: "app.traktor.decks." + safeDeckId
    AppProperty { id: activeCell_slot1; path: deckPath + ".remix.players.1.active_cell_row" }
    AppProperty { id: activeCell_slot2; path: deckPath + ".remix.players.2.active_cell_row" }
    AppProperty { id: activeCell_slot3; path: deckPath + ".remix.players.3.active_cell_row" }
    AppProperty { id: activeCell_slot4; path: deckPath + ".remix.players.4.active_cell_row" }

    RemixDeck { name: "remix"; channel: safeDeckId; size: RemixDeck.Small }
    RemixDeckStepSequencer { name: "remix_sequencer"; channel: safeDeckId; size: RemixDeck.Small }
    Beatgrid { name: "grid"; channel: safeDeckId }

    Loop { name: "loop"; channel: safeDeckId; numberOfLeds: 1; color: LED.legacy(safeDeckId) }
    Blinker { name: "loop_encoder_blinker"; autorun: true; color: LED.legacy(safeDeckId) }
    Blinker { name: "loop_encoder_sequencer_blinker"; color: LED.legacy(safeDeckId); defaultBrightness: dimmed; blinkBrightness: bright }

    AppProperty { id: favoritesSelect; path: "app.traktor.browser.favorites.select" }
    AppProperty { id: isPlaying; path: deckPath + ".running" }
    AppProperty { id: sequencerOn; path: deckPath + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: deckPath + ".remix.sequencer.rec.on";
        onValueChanged: {
            if (sequencerRecOn.value && sequencerOn) {
                sequencerOn.value = true
            }
        }
    }

    // Safe access to parent properties with defaults
    property string deckPropertiesPath: (typeof deck !== 'undefined' && deck && deck.deckPropertiesPath) ? deck.deckPropertiesPath : ("mapping.state." + safeDeckId)
    property string propertiesPath: (typeof deck !== 'undefined' && deck && deck.propertiesPath) ? deck.propertiesPath : "mapping.state"
    MappingPropertyDescriptor { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

    WiresGroup {
        enabled: active

        //Browser
        WiresGroup {
            enabled: (typeof screenView !== 'undefined' && screenView && screenView.value == ScreenView.browser) && (typeof browserIsContentList !== 'undefined' && browserIsContentList && browserIsContentList.value)

            Wire { from: "%surface%.encoder.push"; to: TriggerPropertyAdapter  { path:"app.traktor.browser.flip_sort_up_down" } enabled: ((typeof shift === 'undefined' || !shift || !shift.value) && (typeof loopEncoderInBrowser !== 'undefined' && loopEncoderInBrowser && loopEncoderInBrowser.value == 0)) || ((typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftLoopEncoderInBrowser !== 'undefined' && shiftLoopEncoderInBrowser && shiftLoopEncoderInBrowser.value == 0)) && (browserSortId.value > 0) }
            Wire { from: "%surface%.encoder"; to: RelativePropertyAdapter { path: (typeof seekPreviewPlayer !== 'undefined' && seekPreviewPlayer && seekPreviewPlayer.path) ? seekPreviewPlayer.path : ""; step: 0.01; mode: RelativeMode.Stepped } enabled: ((typeof seekPreviewPlayer !== 'undefined' && seekPreviewPlayer && seekPreviewPlayer.path) && (((typeof shift === 'undefined' || !shift || !shift.value) && (typeof loopEncoderInBrowser !== 'undefined' && loopEncoderInBrowser && loopEncoderInBrowser.value == 1)) || ((typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftLoopEncoderInBrowser !== 'undefined' && shiftLoopEncoderInBrowser && shiftLoopEncoderInBrowser.value == 1)))) }
            Wire { from: "%surface%.encoder.push"; to: TriggerPropertyAdapter   { path: "app.traktor.browser.preview_player.load_or_play" } enabled: ((typeof shift === 'undefined' || !shift || !shift.value) && (typeof loopEncoderInBrowser !== 'undefined' && loopEncoderInBrowser && loopEncoderInBrowser.value == 1)) || ((typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftLoopEncoderInBrowser !== 'undefined' && shiftLoopEncoderInBrowser && shiftLoopEncoderInBrowser.value == 1)) }
        }

        //Deck
        WiresGroup {
            enabled: (typeof screenView !== 'undefined' && screenView && screenView.value == ScreenView.deck)

            WiresGroup {
                enabled: (typeof editMode === 'undefined' || !editMode || editMode.value != EditMode.full) && (typeof slotState === 'undefined' || !slotState || !slotState.value)

                //Default State --> Loop Mode
                WiresGroup {
                    enabled: (typeof holdFreeze === 'undefined' || !holdFreeze || !holdFreeze.value) && (typeof sequencerMode === 'undefined' || !sequencerMode || !sequencerMode.value) && (typeof holdRemix === 'undefined' || !holdRemix || !holdRemix.value) && (typeof holdDeck === 'undefined' || !holdDeck || !holdDeck.value) && (typeof loopInAdjust === 'undefined' || !loopInAdjust || !loopInAdjust.value) && (typeof loopOutAdjust === 'undefined' || !loopOutAdjust || !loopOutAdjust.value)

                    Wire { from: "%surface%.encoder"; to: "loop.autoloop"; enabled: typeof shift === 'undefined' || !shift || !shift.value }
                    Wire { from: "%surface%.encoder"; to: "loop.move"; enabled: typeof shift !== 'undefined' && shift && shift.value }
                    Wire { from: "loop.active"; to: "%surface%.loop.led" }

                    Wire {
                        enabled: typeof shift === 'undefined' || !shift || !shift.value
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: showLoopSize.path }
                    }
                }

                //Loop In/Out Adjust with the Loop Encoder
                WiresGroup {
                    enabled: (typeof holdFreeze === 'undefined' || !holdFreeze || !holdFreeze.value) && (typeof sequencerMode === 'undefined' || !sequencerMode || !sequencerMode.value) && (typeof holdRemix === 'undefined' || !holdRemix || !holdRemix.value) && (typeof holdDeck === 'undefined' || !holdDeck || !holdDeck.value)
/*
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos"; step: 10000; mode: RelativeMode.Stepped } enabled: loopInAdjust.value }
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.length"; step: 10000; mode: RelativeMode.Stepped } enabled: loopInAdjust.value } //necessary to keep the Loop Out on the same position
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.length"; step: 10000; mode: RelativeMode.Stepped } enabled: loopOutAdjust.value }
*/
                }

                //Deck State --> DeckType Selector
                WiresGroup {
                    enabled: (typeof holdDeck !== 'undefined' && holdDeck && holdDeck.value) && !isPlaying.value

                    /* STILL HAVE TO CREATE OVERLAY FOR THE DECK TYPE
                    Wire {
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: (typeof screenOverlay !== 'undefined' && screenOverlay && screenOverlay.path) ? screenOverlay.path : ""; value: Overlay.deck }
                    }
                    */
                    Wire { from: "%surface%.encoder.turn"; to: EncoderScriptAdapter { onIncrement: { if (typeof deck !== 'undefined' && deck) { deck.deckType = (deck.deckType == 3) ? 0 : (deck.deckType + 1) } } onDecrement: { if (typeof deck !== 'undefined' && deck) { deck.deckType = (deck.deckType == 0) ? 3 : (deck.deckType - 1) } } } }
                    Wire { from: "%surface%.encoder.leds";  to: "loop_encoder_blinker" }
                }

                //Freeze State --> Freeze Slicer Size
                WiresGroup {
                    enabled: (typeof holdFreeze !== 'undefined' && holdFreeze && holdFreeze.value) //state only enabled if deck is active

                    Wire {
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: (typeof screenOverlay !== 'undefined' && screenOverlay && screenOverlay.path) ? screenOverlay.path : ""; value: Overlay.slice }
                    }

                    //Wire { from: "%surface%.encoder.touch"; to: ButtonScriptAdapter { onPress: { exitFreeze = false } } }
                    Wire { from: "%surface%.loop.led";  to: "loop_encoder_blinker" }
                    Wire { from: "%surface%.encoder.turn"; to: (typeof freeze_slicer !== 'undefined' && freeze_slicer) ? "freeze_slicer.slice_size" : ""; enabled: (typeof isInActiveLoop === 'undefined' || !isInActiveLoop || !isInActiveLoop.value) && (typeof freeze_slicer !== 'undefined' && freeze_slicer) }
                    //Wire { from: "%surface%.encoder.turn"; to: "loop.autoloop"; enabled: isInActiveLoop.value }
                }

                //Sequencer State --> Pattern Length
                WiresGroup {
                    enabled: (typeof sequencerMode !== 'undefined' && sequencerMode && sequencerMode.value)
                    Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.selected_slot_pattern_length"; enabled: typeof shift === 'undefined' || !shift || !shift.value } //FIX TO EDIT SLOTS 2-4 ("app.traktor.decks.X.remix.players.Y.sequencer.pattern_length")
                    Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.all_slots_pattern_length"; enabled: typeof shift !== 'undefined' && shift && shift.value }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.sequencer.on" } }
                    Wire { from: "loop_encoder_sequencer_blinker"; to: "%surface%.loop.led" }
                    Wire { from: "loop_encoder_sequencer_blinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (sequencerOn && sequencerOn.value) ? true : false } }
                }
            }

            //Edit Mode (S5 Only)
            WiresGroup {
                enabled: (typeof editMode !== 'undefined' && editMode && editMode.value == EditMode.full)

                Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: propertiesPath + ".encoderScanMode" } }
                Wire { from: "%surface%.encoder.turn"; to: EncoderScriptAdapter { onIncrement: { if (typeof scanDirection !== 'undefined' && scanDirection && typeof scanUpdater !== 'undefined' && scanUpdater) { scanDirection.value = 4; scanUpdater.value = !scanUpdater.value } } onDecrement: { if (typeof scanDirection !== 'undefined' && scanDirection && typeof scanUpdater !== 'undefined' && scanUpdater) { scanDirection.value = -4; scanUpdater.value = !scanUpdater.value } } } enabled: (typeof encoderScanMode !== 'undefined' && encoderScanMode && encoderScanMode.value) }

                WiresGroup {
                    enabled: (typeof zoomedEditView === 'undefined' || !zoomedEditView || !zoomedEditView.value) && (typeof encoderScanMode === 'undefined' || !encoderScanMode || !encoderScanMode.value)
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_coarse"; enabled: typeof shift === 'undefined' || !shift || !shift.value }
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_fine"; enabled: typeof shift !== 'undefined' && shift && shift.value }
                }
                WiresGroup {
                    enabled: (typeof zoomedEditView !== 'undefined' && zoomedEditView && zoomedEditView.value) && (typeof encoderScanMode === 'undefined' || !encoderScanMode || !encoderScanMode.value)
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_fine"; enabled: typeof shift === 'undefined' || !shift || !shift.value }
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_ultrafine"; enabled: typeof shift !== 'undefined' && shift && shift.value }
                }
            }
        }
    }

    WiresGroup {
        enabled: (typeof deck !== 'undefined' && deck && deck.footerControlled)

        WiresGroup {
            enabled: (typeof deck !== 'undefined' && deck && deck.deckType == DeckType.Remix)

            //Remix State --> Remix Deck Capture Source
            WiresGroup {
                enabled: (typeof holdRemix !== 'undefined' && holdRemix && holdRemix.value) //state only enabled if remix is controlled
                Wire {
                    from: Or {
                        inputs:
                        [
                            //"%surface%.encoder.touch", disabled so that we can use the encoder to Toggle the Rec Mode too
                            "%surface%.encoder.is_turned"
                        ]
                    }
                    to: HoldPropertyAdapter { path: (typeof screenOverlay !== 'undefined' && screenOverlay && screenOverlay.path) ? screenOverlay.path : ""; value: Overlay.capture }
                }
                Wire { from: "%surface%.encoder.turn"; to: "remix.capture_source" }
                Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.sequencer.rec.on" } } //enabled: activePadsMode.value == PadsMode.remix }
                Wire { from: "loop_encoder_blinker"; to: "%surface%.loop.led" }
            }

            //Remix Parameters
            WiresGroup {
                enabled: (typeof slotState !== 'undefined' && slotState && slotState.value) && (typeof screenOverlay === 'undefined' || !screenOverlay || screenOverlay.value == Overlay.none)

                WiresGroup {
                    enabled: (typeof slot1Selected !== 'undefined' && slot1Selected && slot1Selected.value)

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.1.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) && (typeof sequencerSampleLockSlot1 === 'undefined' || !sequencerSampleLockSlot1 || !sequencerSampleLockSlot1.value) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot1" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.1.filter_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.cell.columns.1.rows." + ((activeCell_slot1 && activeCell_slot1.value !== undefined) ? (activeCell_slot1.value+1) : 1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.1.key_lock" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.1.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.1.fx_send_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                }

                WiresGroup {
                    enabled: (typeof slot2Selected !== 'undefined' && slot2Selected && slot2Selected.value)

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.2.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) && (typeof sequencerSampleLockSlot2 === 'undefined' || !sequencerSampleLockSlot2 || !sequencerSampleLockSlot2.value) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot2" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.2.filter_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.cell.columns.2.rows." + ((activeCell_slot2 && activeCell_slot2.value !== undefined) ? (activeCell_slot2.value+1) : 1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.2.key_lock" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }


                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.2.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.2.fx_send_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                }

                WiresGroup {
                    enabled: (typeof slot3Selected !== 'undefined' && slot3Selected && slot3Selected.value)

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.3.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) && (typeof sequencerSampleLockSlot3 === 'undefined' || !sequencerSampleLockSlot3 || !sequencerSampleLockSlot3.value) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot3" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.3.filter_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.cell.columns.3.rows." + ((activeCell_slot3 && activeCell_slot3.value !== undefined) ? (activeCell_slot3.value+1) : 1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.3.key_lock" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.3.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.3.fx_send_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                }

                WiresGroup {
                    enabled: (typeof slot4Selected !== 'undefined' && slot4Selected && slot4Selected.value)

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.4.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) && (typeof sequencerSampleLockSlot4 === 'undefined' || !sequencerSampleLockSlot4 || !sequencerSampleLockSlot4.value) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot4" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 1) }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.4.filter_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 2) }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.cell.columns.4.rows." + ((activeCell_slot4 && activeCell_slot4.value !== undefined) ? (activeCell_slot4.value+1) : 1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.4.key_lock" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 3) }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".remix.players.4.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".remix.players.4.fx_send_on" } enabled: (typeof performanceEncoderControls !== 'undefined' && performanceEncoderControls && performanceEncoderControls.value == 4) }
                }
            }
        }

        WiresGroup {
            enabled: (typeof deck !== 'undefined' && deck && deck.deckType == DeckType.Stem)

            //Stem Parameters
            WiresGroup {
                enabled: (typeof slotState !== 'undefined' && slotState && slotState.value) && (typeof screenOverlay === 'undefined' || !screenOverlay || screenOverlay.value == Overlay.none)

                WiresGroup {
                    enabled: (typeof slot1Selected !== 'undefined' && slot1Selected && slot1Selected.value)

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".stems.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".stems.1.filter_on" } enabled: typeof shift === 'undefined' || !shift || !shift.value }
                        WiresGroup {
                            enabled: typeof shift !== 'undefined' && shift && shift.value
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.1.filter" : "" }
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.1.filter_on" : "" }
                        }
                    }
                }

                WiresGroup {
                    enabled: (typeof slot2Selected !== 'undefined' && slot2Selected && slot2Selected.value)

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".stems.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".stems.2.filter_on" } enabled: typeof shift === 'undefined' || !shift || !shift.value }
                        WiresGroup {
                            enabled: typeof shift !== 'undefined' && shift && shift.value
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.2.filter" : "" }
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.2.filter_on" : "" }
                        }
                    }
                }

                WiresGroup {
                    enabled: (typeof slot3Selected !== 'undefined' && slot3Selected && slot3Selected.value)

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".stems.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".stems.3.filter_on" } enabled: typeof shift === 'undefined' || !shift || !shift.value }
                        WiresGroup {
                            enabled: typeof shift !== 'undefined' && shift && shift.value
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.3.filter" : "" }
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.3.filter_on" : "" }
                        }
                    }
                }

                WiresGroup {
                    enabled: (typeof slot4Selected !== 'undefined' && slot4Selected && slot4Selected.value)

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: deckPath + ".stems.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPath + ".stems.4.filter_on" } enabled: typeof shift === 'undefined' || !shift || !shift.value }
                        WiresGroup {
                            enabled: typeof shift !== 'undefined' && shift && shift.value
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.4.filter" : "" }
                            Wire { from: "%surface%.encoder.push"; to: (typeof reset_stems !== 'undefined' && reset_stems) ? "reset_stems.4.filter_on" : "" }
                        }
                    }
                }
            }
        }
    }
}
