//
//  CrashSignalExceptionSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

typealias SignalHandler = (Int32, UnsafeMutablePointer<__siginfo>?, UnsafeMutableRawPointer?) -> Void
private var previousABRTSignalHandler : SignalHandler?
private var previousBUSSignalHandler  : SignalHandler?
private var previousFPESignalHandler  : SignalHandler?
private var previousILLSignalHandler  : SignalHandler?
private var previousPIPESignalHandler : SignalHandler?
private var previousSEGVSignalHandler : SignalHandler?
private var previousSYSSignalHandler  : SignalHandler?
private var previousTRAPSignalHandler : SignalHandler?
private let preHandlers = [SIGABRT : previousABRTSignalHandler,
                           SIGBUS : previousBUSSignalHandler,
                           SIGFPE : previousFPESignalHandler,
                           SIGILL : previousILLSignalHandler,
                           SIGPIPE : previousPIPESignalHandler,
                           SIGSEGV : previousSEGVSignalHandler,
                           SIGSYS : previousSYSSignalHandler,
                           SIGTRAP : previousTRAPSignalHandler]

class CrashSignalExceptionHandler {
    func action() {
        backupOriginalHandler()
        signalNewRegister()
    }

    func backupOriginalHandler() {
        for (signal, handler) in preHandlers {
            var tempHandler = handler
            backupSingleHandler(signal: signal, preHandler: &tempHandler)
        }
        /*
        let empty: UnsafeMutablePointer<sigaction>? = nil
        var old_action_abrt = sigaction()
        sigaction(SIGABRT, empty, &old_action_abrt)
        if old_action_abrt.__sigaction_u.__sa_sigaction != nil {
            previousABRTSignalHandler = old_action_abrt.__sigaction_u.__sa_sigaction
        }

        var old_action_bus = sigaction()
        sigaction(SIGBUS, empty, &old_action_bus)
        if old_action_bus.__sigaction_u.__sa_sigaction != nil {
            previousBUSSignalHandler = old_action_bus.__sigaction_u.__sa_sigaction
        }

        var old_action_fpe = sigaction()
        sigaction(SIGFPE, empty, &old_action_fpe)
        if old_action_fpe.__sigaction_u.__sa_sigaction != nil {
            previousFPESignalHandler = old_action_fpe.__sigaction_u.__sa_sigaction
        }

        var old_action_ill = sigaction()
        sigaction(SIGILL, empty, &old_action_ill)
        if old_action_ill.__sigaction_u.__sa_sigaction != nil {
            previousILLSignalHandler = old_action_ill.__sigaction_u.__sa_sigaction
        }

        var old_action_pipe = sigaction()
        sigaction(SIGPIPE, empty, &old_action_pipe)
        if old_action_pipe.__sigaction_u.__sa_sigaction != nil {
            previousPIPESignalHandler = old_action_pipe.__sigaction_u.__sa_sigaction
        }

        var old_action_segv = sigaction()
        sigaction(SIGSEGV, empty, &old_action_segv)
        if old_action_segv.__sigaction_u.__sa_sigaction != nil {
            previousSEGVSignalHandler = old_action_segv.__sigaction_u.__sa_sigaction
        }

        var old_action_sys = sigaction()
        sigaction(SIGSYS, empty, &old_action_sys)
        if old_action_sys.__sigaction_u.__sa_sigaction != nil {
            previousSYSSignalHandler = old_action_sys.__sigaction_u.__sa_sigaction
        }

        var old_action_trap = sigaction()
        sigaction(SIGTRAP, empty, &old_action_trap)
        if old_action_trap.__sigaction_u.__sa_sigaction != nil {
            previousTRAPSignalHandler = old_action_trap.__sigaction_u.__sa_sigaction
        }
 */
    }

    func backupSingleHandler(signal: Int32, preHandler: inout SignalHandler?) {
        let empty: UnsafeMutablePointer<sigaction>? = nil
        var old_action_abrt = sigaction()
        sigaction(signal, empty, &old_action_abrt)
        if old_action_abrt.__sigaction_u.__sa_sigaction != nil {
            preHandler = old_action_abrt.__sigaction_u.__sa_sigaction
        }
    }

    func signalNewRegister() {
        SoldierSignalRegister(signal: SIGABRT)
        SoldierSignalRegister(signal: SIGBUS)
        SoldierSignalRegister(signal: SIGFPE)
        SoldierSignalRegister(signal: SIGILL)
        SoldierSignalRegister(signal: SIGPIPE)
        SoldierSignalRegister(signal: SIGSEGV)
        SoldierSignalRegister(signal: SIGSYS)
        SoldierSignalRegister(signal: SIGTRAP)
    }
}

func SoldierSignalRegister(signal: Int32) {
    var action = sigaction()
    action.__sigaction_u.__sa_sigaction = SoldierSignalHandler
    action.sa_flags = SA_NODEFER | SA_SIGINFO
    sigemptyset(&action.sa_mask)
    let empty: UnsafeMutablePointer<sigaction>? = nil
    sigaction(signal, &action, empty)
}

func SoldierSignalHandler(signal: Int32, info: UnsafeMutablePointer<__siginfo>?, context: UnsafeMutableRawPointer?) {
    var exceptionInfo = "Signal Exception:\n"
    exceptionInfo.append("Signal \(SignalName(signal)) was raised.\n")
    exceptionInfo.append("Call Stack:\n")
    let callStackSymbols = Thread.callStackSymbols
    for index in 0..<callStackSymbols.count {
        exceptionInfo.append("\(callStackSymbols[index])\n")
    }
    exceptionInfo.append("threadInfo:\n")
    exceptionInfo.append(Thread.current.description)
    UserDefaults.standard.set("signal:\(exceptionInfo)", forKey: "ksignal")
    CrashFileManager.saveCrashInfo(exceptionInfo, crashTypeName: "Crash(Signal)")
    ClearSignalRigister()
    //调用之前的handler
    let handler = preHandlers[signal]
    handler??(signal, info, context)
    kill(getpid(), SIGKILL)
}

func SignalName(_ signal: Int32) -> String {
    switch signal {
        case SIGABRT: return "SIGABRT"
        case SIGBUS: return "SIGBUS"
        case SIGFPE: return "SIGFPE"
        case SIGILL: return "SIGILL"
        case SIGPIPE: return "SIGPIPE"
        case SIGSEGV: return "SIGSEGV"
        case SIGSYS: return "SIGSYS"
        case SIGTRAP: return "SIGTRAP"
        default: return "None"
    }
}

func ClearSignalRigister() {
    signal(SIGSEGV,SIG_DFL);
    signal(SIGFPE,SIG_DFL);
    signal(SIGBUS,SIG_DFL);
    signal(SIGTRAP,SIG_DFL);
    signal(SIGABRT,SIG_DFL);
    signal(SIGILL,SIG_DFL);
    signal(SIGPIPE,SIG_DFL);
    signal(SIGSYS,SIG_DFL);
}

