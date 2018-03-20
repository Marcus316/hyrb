#!/usr/bin/env hy

(import socket time re random os sys)

(def ircsock (.socket socket socket.AF_INET socket.SOCK_STREAM))
(def botnick "hyrb")
(def host "tilde.town")
(def port 6667)
(def channel "#tildetown")

(def privmsg "PRIVMSG")

(defn connect
  []
  (.connect ircsock (tuple [host port]))
  (pong)
  (.send ircsock (bytes (.format "NICK {}\r\n" botnick) "utf-8"))
  (.send ircsock (bytes (.format "USER {} {} {} :{}\r\n" botnick botnick botnick botnick) "utf-8"))
  (.send ircsock (bytes (.format "JOIN {}\r\n" channel) "utf-8"))
  (print (+ botnick " has connected to " host " on port " (string port) " in the channel " channel))
  (find-stuff))

(defn pong
  []
  (.send ircsock (bytes "PONG :message\r\n" "utf-8")))

(defn send-message
  [sendchannel usermessage]
  (.send ircsock (bytes (.format "{} {} :{}\r\n" privmsg sendchannel usermessage) "utf-8")))

(defn find-trigger
  [command some-string]
  (.findall re (.format "{} {} :{}\r\n" privmsg channel command) some-string re.IGNORECASE))

(defn find-sender
  [command some-string]
  (.findall re (.format "!~(.*)@.* {} {} :{}\r\n" privmsg channel command) some-string re.IGNORECASE))

(defn find-ping
  [some-string]
  (setv ping (.findall re (.format "PING :{}\r\n" host) some-string)))

(defn leave
  []
  (.send ircsock (bytes "QUIT :leaving\r\n" "utf-8"))
  (print botnick + " disconnected from the host")
  (.exit sys))

(defn run-command
  [command]
  (.rstrip (.read (.popen os (.format "{}" command))) "\n"))

(defn find-stuff
  []
  (while True
    (setv hostdata (str (.decode (.recv ircsock 1024) "utf-8" "replace")))
    (setv ping (find-ping hostdata))

    (setv rollcall (find-trigger "!rollcall" hostdata))
    (setv ram (find-trigger "!ram" hostdata))
    (setv water (find-trigger (.format "!water ({})\s?" botnick) hostdata))
    (setv hug (find-trigger "!hug" hostdata))
    (setv hug-someone (find-trigger "!hug (.*)" hostdata))
    (setv sucks (find-trigger "!sucks (.*)" hostdata))
    (setv church (find-trigger "!church" hostdata))
    (setv leaving (find-trigger "!leave" hostdata))

    ;;uncomment this to view host messages
    (print(repr hostdata))

    (if rollcall
      (do
        (setv rollcall-response "Hello! I am Hyrb! I am m455's bot. I respond to !rollcall, !ram, !water hyrb, !hug, !hug type-someone/something, !sucks type-something-that-sucks, !church")
        (send-message channel rollcall-response)))

    (if ram
      (do
        (setv ram-response (run-command "ram"))
        (send-message channel ram-response)))

    (if water
      (do
        (setv water-response (.choice random ["hey now"
                                              "\uFFFD?\u25A1\uFFFDMY\uFFFDEYES!"
                                              "IT BURNSSSS!"
                                              "ohmy, you did me a frighten"
                                              "stop that"]))
        (send-message channel water-response)))

    (if hug
      (do
        (setv hug-receiver (find-sender "!hug" hostdata))
        (setv hug-response (.choice random [(.format "*offers {} hugs because they deserve it*" (get hug-receiver 0))
                                            (.format "*offers {} a biggggggg warm bot hug*" (get hug-receiver 0))
                                            (.format "hello {}. if you want a nice comforting bot hug right now, i'm always here for you!" (get hug-receiver 0))
                                            (.format "*offers {} a nice tight hug*" (get hug-receiver 0))]))
        (send-message channel hug-response)))

    (if hug-someone
      (do
        (setv hug-response (.choice random [(.format "*offers {} hugs because they deserve it*" (.rstrip (get hug-someone 0) " "))
                                            (.format "*offers {} a biggggggg warm bot hug*" (.rstrip (get hug-someone 0) " "))
                                            (.format "hello {}. if you want a nice comforting bot hug right now, i'm always here for you!" (.rstrip (get hug-someone 0) " "))
                                            (.format "*offers {} a nice tight hug*" (.rstrip (get hug-someone 0) " "))]))
        (send-message channel hug-response)))

    (if sucks
      (do
        (setv sucks-response (.choice random [(.format "you know what sucks? {} sucks!" (.rstrip (get sucks 0)" "))
                                              (.format "fuck, {}, sucks!" (.rstrip (get sucks 0) " "))
                                              (.format "{} sucks." (.rstrip (get sucks 0) " "))
                                              (.format "i completely agree with you! {} sucks!" (.rstrip (get sucks 0) " "))]))
        (send-message channel sucks-response)))

    (if church
      (do
        (setv pre (.choice random ["in this very moment in time"
                                   "right at this second"
                                   "most likely"
                                   "presumptuously"]))

        (setv pre2 (.choice random ["in this very moment in time"
                                    "right at this second"
                                    "most likely"
                                    "presumptuously"]))

        (setv member-plural (.choice random ["buddies"
                                             "folks"
                                             "tildelings"
                                             "cuties"
                                             "townies"]))

        (setv member-singular (.choice random ["buddy"
                                               "folk"
                                               "tildeling"
                                               "cutie"
                                               "townie"]))

        (setv intensifier (.choice random ["utmost"
                                           "most"
                                           "fucking"
                                           "hella"
                                           "most"
                                           "real"
                                           "terribly"
                                           "dreadfully"
                                           "awefully"
                                           "extremely"
                                           "caringly"
                                           "soothingly"
                                           "dead"
                                           "rather"
                                           "somewhat"
                                           "surpassingly"
                                           "excessively"
                                           "colossally"
                                           "frightfully"
                                           "astoundingly"
                                           "exceptionally"
                                           "strikingly"
                                           "right"]))

        (setv intensifier2 (.choice random ["utmost"
                                            "most"
                                            "fucking"
                                            "hella"
                                            "most"
                                            "real"
                                            "terribly"
                                            "dreadfully"
                                            "awefully"
                                            "extremely"
                                            "caringly"
                                            "soothingly"
                                            "dead"
                                            "rather"
                                            "somewhat"
                                            "surpassingly"
                                            "excessively"
                                            "colossally"
                                            "frightfully"
                                            "astoundingly"
                                            "exceptionally"
                                            "strikingly"
                                            "right"]))

        (setv adjective (.choice random ["great"
                                         "precious"
                                         "holy"
                                         "cyber beneticted"
                                         "blessed"
                                         "sweet"
                                         "cute"
                                         "dear"]))

        (setv adjective2 (.choice random ["great"
                                          "precious"
                                          "holy"
                                          "cyber beneticted"
                                          "blessed"
                                          "sweet"
                                          "cute"
                                          "dear"]))

        (setv random-structure (.choice random [(+ pre " it is said that " member-plural " of the church of tilde are " pre2 " "  intensifier " " adjective)
                                                (+ "behold the " adjective " as fuck " member-plural " of the church of tilde")
                                                (+ "the church of tilde is one " adjective "-ass church")
                                                (+ "when you're a " intensifier " " adjective " " member-singular " of the church, you feel " intensifier2 " "  adjective2 " every day")]))

        (send-message channel random-structure)))

    (if ping
      (do
        (pong)))

    (if leaving
      (do
        (leave)))

    (.sleep time 1)))

(defn main
      []
      (connect))

(main)
