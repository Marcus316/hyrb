#!/usr/bin/env hy
; a possible rewrite of emfor in hy
(import socket time re random os)

(def ircsock (.socket socket socket.AF_INET socket.SOCK_STREAM))
(def botnick "hyrb")
(def host "tilde.town")
(def port 6667)
(def channel "#tildetown")
(def privmsg "PRIVMSG")

(defn connect
      []
      (.connect ircsock (tuple [host port]));;blahhh can't figure this part out
      (pong)
      (.send ircsock (bytes (.format "NICK {}\r\n" botnick) "utf-8"))
      (.send ircsock (bytes (.format "USER {} {} {} :{}\r\n" botnick botnick botnick botnick) "utf-8"))
      (.send ircsock (bytes (.format "JOIN {}\r\n" channel) "utf-8"))
      (print (+ botnick " has connected to the host")))

(defn pong
      []
      (.send ircsock (bytes "PONG :message\r\n" "utf-8")))

(defn send-message
      [usermessage]
      (.send ircsock (bytes (.format "{} {} :{}\r\n" privmsg channel usermessage) "utf-8")))

(defn find-command
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
             (setv rollcall (find-command "!rollcall" hostdata))
             (setv cpu (find-command "!cpu" hostdata))
             (setv weather (find-command "!weather ([a-zA-z]+ [a-zA-Z]+)" hostdata))
             (setv water (find-command (.format "!water {}\s?" botnick) hostdata))
             (setv hug (find-command "!hug" hostdata))
             (setv hug-someone (find-command "!hug (.*)" hostdata))
             (setv sucks (find-command "!sucks (.*)" hostdata))
             (setv ping(find-ping hostdata))
             ;;uncomment this to view host messages
             ;;(print(repr hostdata))

             (if rollcall
               (do
                 (setv rollcall-response "Hello! I am Hyrb! I am m455's bot. I respond to !rollcall, !cpu, !weather yourcounrty yourcity, !water hyrb, !hug, !hug someone, and !sucks typewhatsucks")
                 (send-message rollcall-response)
                 (.sleep time 1)))

             (if cpu
               (do
                 (setv cpu-response (run-command "cpu"))
                 (send-message cpu-response)
                 (.sleep time 1)))

             (if weather
               (do
                 (setv weather-response (run-command (.format "hycast {}" (get weather 0))))
                 (send-message weather-response)
                 (.sleep time 1)))

             (if water
               (do
                 (setv water-response (.choice random ["hey now" 
                                                       "\uFFFD?\u25A1\uFFFDMY\uFFFDEYES!"
                                                       "IT BURNSSSS!"
                                                       "ohmy, you did me a frighten"
                                                       "stop that"]))
                 (send-message water-response)
                 (.sleep time 1)))

            (if hug
              (do
                (setv hug-receiver (find-sender "!hug" hostdata))
                (setv hug-response (.choice random [(.format "*hugs {} because they deserve it*" (get hug-receiver 0))
                                                    (.format "*gives {} a biggggggg warm bot hug*" (get hug-receiver 0))
                                                    (.format "*hugs {} tightly*" (get hug-receiver 0))]))
                (send-message hug-response)
                (.sleep time 1)))

            (if hug-someone
              (do
                (setv hug-response (.choice random [(.format "*hugs {} because they deserve it*" (get hug-someone 0))
                                                    (.format "*gives {} a biggggggg warm bot hug*" (get hug-someone 0))
                                                    (.format "*hugs {} tightly*" (get hug-someone 0))]))
                (send-message hug-response)
                (.sleep time 1)))

            (if sucks
              (do
                (setv sucks-response (.choice random [(.format "you know what sucks? {} sucks!" (get sucks 0))
                                                      (.format "fuck, {}, sucks!" (get sucks 0))
                                                      (.format "{} sucks." (get sucks 0))
                                                      (.format "i completely agree with you! {} sucks!" (get sucks 0))]))
                (send-message sucks-response)
                (.sleep time 1)))

             (if ping
               (do
                 (pong)
                 (.sleep time 1)))))

(defn main
      []
      (connect)
      (find-stuff))

(main)
