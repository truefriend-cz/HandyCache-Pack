--[[ <HCExtension>
@name			Ad-Block
@author			truefriend-cz / internet sources
@version		1.2
@description	Script for filtering domains and URL words (must use with truefriend-cz script pack only) - Extension list position priority: 2
@license		CC BY-NC-SA (Attribution-NonCommercial-ShareAlike - https://creativecommons.org/licenses/by-nc-sa/)
@event 			RequestHeaderReceived
</HCExtension> ]]

function RequestHeaderReceived()

	local whitelist = {'googleusercontent.com'}
	local blacklist = {'adblock-test', 'trafficflux', '007-gateway.com', 'admedia.com', 'affiliationcash.com', 'bstrtb.com', 'deplayer.net', 'futureresiduals.com', 'iunbrudy.net', 'milabra.com', 'performanceadvertising.mobi', 'saltamendors.com', 'tldadserv.com', 'wigetstudios.com',
				'juicyads.com', 'vivastreet.co.uk', '0icep80f.com', 'ad-media.org', 'affiliation-france.com', 'btnibbler.com', 'deployads.com', 'futureus.com', 'ivism.org', 'millennialmedia.com', 'performance-based.com', 'salvador24.com', 'tlvmedia.com', 'winbuyer.com',
				'traffichunt.com', 'trafficstars.com', 'adxpansion.com', 'tynt.com', '101m3.com', 'admedias.net', 'affiliationworld.com', 'btrll.com', 'derlatas.com', 'fwmrm.net', 'iwantmoar.net', 'millionairesurveys.com', 'performancetrack.info', 'saple.net', 'tnyzin.ru', 'wingads.com',
				'103092804.com', 'admedo.com', 'affiliationzone.com', 'bttbgroup.com', 'destinationurl.com', 'fxdepo.com', 'ixnp.com', 'minimumpay.info', 'performancingads.com', 'sascdn.com', 'toboads.com', 'winsspeeder.info',
				'10fbb07a4b0.se', 'admeld.com', 'affilijack.de', 'bu520.com', 'detroposal.com', 'fxyc0dwa.com', 'izeads.com', 'mirago.com', 'permutive.com', 'satgreera.com', 'tokenads.com', 'wlmarketing.com',
				'10pipsaffiliates.com', 'admeta.com', 'affiliproducts.com', 'bubblesmedia.ru', 'deuskex.link', 'g05.info', 'j2ef76da3.website', 'mirrorpersonalinjury.co.uk', 'persevered.com', 'saveads.net', 'tollfreeforwarding.com', 'wmmediacorp.com',
				'1100i.com', 'admission.net', 'affiliserve.com', 'bucketsofbanners.com', 'developermedia.com', 'g4whisperermedia.com', 'jadcenter.com', 'miva.com', 'pexu.com', 'saveads.org', 'tomekas.com', 'wonclick.com',
				'123date.me', 'admitad.com', 'affimo.de', 'budgetedbauer.com', 'deximedia.com', 'gagacon.com', 'jango.com', 'mixmarket.biz', 'pezrphjl.com', 'sayadcoltd.com', 'tonefuse.com', 'wonderlandads.com',
				'123vidz.com', 'admixer.net', 'affinitad.com', 'budurl.com', 'dexplatform.com', 'gagenez.com', 'jangonetwork.com', 'mixpo.com', 'pgmediaserve.com', 'saymedia.com', 'tool-site.com', 'wootmedia.net',
				'152media.com', 'admngronline.com', 'affinity.com', 'buhafr.net', 'dgmatix.com', 'gainmoneyfast.com', 'jaspensar.com', 'mkhoj.com', 'pgpartner.com', 'sba.about.co.kr', 'top26.net', 'wopdi.com',
				'15f3c01a.info', 'admob.com', 'affiz.net', 'buildtrafficx.com', 'dgmaustralia.com', 'galleyn.com', 'jbrlsr.com', 'mktmobi.com', 'pgssl.com', 'sbaffiliates.com', 'topauto10.com', 'wordbankads.com',
				'15f3c01c.info', 'admpads.com', 'affplanet.com', 'bulletproofserving.com', 'dgmaxinteractive.com', 'gambling-affiliation.com', 'jdoqocy.com', 'mktseek.com', 'pharmcash.com', 'sbcpower.com', 'topcasino10.com', 'wordego.com',
				'174.142.194.177', 'admtpmp127.com', 'afftrack.com', 'bunchofads.com', 'dhundora.com', 'gameads.com', 'jdproject.net', 'mlnadvertising.com', 'pheedo.com', 'scanmedios.com', 'topdi.net', 'worlddatinghere.com',
				'17a898b9.info', 'admulti.com', 'aflrm.com', 'bunny-net.com', 'diamondtraff.com', 'game-advertising-online.com', 'jdrm4.com', 'mmadsgadget.com', 'philbardre.com', 'scanscout.com', 'topeuro.biz', 'worldrewardcenter.net',
				'17a898bb.info', 'admzn.com', 'africawin.com', 'burbanked.info', 'dianomioffers.co.uk', 'gamecetera.com', 'jdtracker.com', 'mmgads.com', 'philipstreehouse.info', 'sceno.ru', 'topfox.co.uk', 'worthathousandwords.com',
				'188server.com', 'adne.tv', 'afterdownload.com', 'burjam.com', 'digipathmedia.com', 'game-clicks.com', 'jeetyetmedia.com', 'mmismm.com', 'philosophere.com', 'scootloor.com', 'tophotoffers.com', 'worthyadvertising.com',
				'18clicks.com', 'adnectar.com', 'afterdownloads.com', 'burnsoftware.info', 'digitrevenue.com', 'gamehotus.com', 'jellr.net', 'mmngte.net', 'phonespybubble.com', 'scratchaffs.com', 'topshelftraffic.com', 'wuarnurf.net',
				'194.71.107.25', 'adnet.biz', 'afy11.net', 'burstnet.com', 'dilpy.org', 'gamersad.com', 'jemmgroup.com', 'mmondi.com', 'pianobuyerdeals.com', 'search123.uk.com', 'torads.me', 'wuatriser.net',
				'1clickdownloads.com', 'adnet.com', 'agcdn.com', 'businesscare.com', 'dinclinx.com', 'gamersbanner.com', 'jiwire.com', 'mmotraffic.com', 'picadmedia.com', 'seccoads.com', 'torconpro.com', 'wudr.net',
				'1e0y.xyz', 'adnet.de', 'agentcenters.com', 'businessclick.com', 'dipads.net', 'gamesbannerexchange.com', 'jizzontoy.com', 'moatads.com', 'picbucks.com', 'secondstreetmedia.com', 'torerolumiere.net', 'wulium.com',
				'1phads.com', 'adnet.lt', 'aggregateknowledge.com', 'busterzaster.de', 'directaclick.com', 'gamesrevenue.com', 'jmp9.com', 'mobatori.com', 'picsti.com', 'secureintl.com', 'toroadvertising.com', 'wurea.com',
				'1sadx.net', 'adnet.ru', 'aglocobanners.com', 'buxflow.com', 'directile.info', 'gandrad.org', 'jo7cofh3.com', 'mobatory.com', 'pictela.net', 'securesoft.info', 'toroadvertisingmedia.com', 'wwbn.com',
				'1yk851od.com', 'adnet.vn', 'agmtrk.com', 'buxp.org', 'directile.net', 'ganja.com', 'jobsyndicate.com', 'mobday.com', 'pikkr.net', 'secure-softwaremanager.com', 'torrida.net', 'wwv4ez0n.com',
				'206ads.com', 'adnet-media.net', 'agvzvwof.com', 'buxx.mobi', 'directleads.com', 'gannett.gcion.com', 'jobtarget.com', 'mobgold.com', 'pinballpublishernetwork.com', 'securewebsiteaccess.com', 'torrpedoads.net', 'wwwadcntr.com',
				'20dollars2surf.com', 'adnetworkme.com', 'aim4media.com', 'buyflood.com', 'directoral.info', 'garristo.com', 'joytocash.com', 'mobicont.com', 'pioneeringad.com', 'securitain.com', 'totaladperformance.com', 'wwwpromoter.com',
				'213.163.70.183', 'adnext.fr', 'aimatch.com', 'buyorselltnhomes.com', 'directorym.com', 'garvmedia.com', 'jque.net', 'mobifobi.com', 'pipaoffers.com', 'sedoparking.com', 'total-media.net', 'wzus1.ask.com',
				'247realmedia.com', 'adngin.com', 'airpush.com', 'buysellads.com', 'directrev.com', 'gate-ru.com', 'js.cdn.ac', 'mobikano.com', 'piticlik.com', 'seductionprofits.com', 'totalprofitplan.com', 'x.mochiads.com',
				'254a.com', 'adnimation.com', 'ajansreklam.net', 'buzzcity.net', 'directtrack.com', 'gatikus.com', 'jscount.com', 'mobile-10.com', 'pivotalmedialabs.com', 'seekads.net', 'totemcash.com', 'x4300tiz.com',
				'2d4c3870.info', 'adnium.com', 'alchemysocial.com', 'buzzparadise.com', 'directtrk.com', 'gayadnetwork.com', 'jsfeedadsget.com', 'mobileraffles.com', 'pivotrunner.com', 'sekindo.com', 'totrack.ru', 'xad.com',
				'2d4c3872.info', 'adnoble.com', 'alfynetwork.com', 'bwinpartypartners.com', 'dispop.com', 'g-cash.biz', 'jsretra.com', 'mobiright.com', 'pixazza.com', 'selectr.net', 'tower-colocation.de', 'xadcentral.com',
				'2dpt.com', 'adnow.com', 'alimama.com', 'byspot.com', 'distantnews.com', 'geede.info', 'jssearch.net', 'mobisla.com', 'pixeltrack66.com', 'sellhealth.com', 'tower-colocation.info', 'xcelltech.com',
				'2mdn.info', 'adnxs.com', 'allabc.com', 'byzoo.org', 'distantstat.com', 'geek2us.net', 'jtrakk.com', 'mobitracker.info', 'pixfuture.net', 'selsin.net', 'tpnads.com', 'xcelsiusadserver.com',
				'2mdn.net', 'adnxs.net', 'alleliteads.com', 'bzrvwbsh5o.com', 'districtm.ca', 'gefhasio.com', 'judicated.com', 'mobiyield.com', 'pixxur.com', 'sendptp.com', 'tqlkg.com', 'xchangebanners.com',
				'2xbpub.com', 'adnxs1.com', 'allianrd.net', 'c8.net.ua', 'dl-rms.com', 'geld-internet-verdienen.net', 'juiceadv.com', 'mobizme.net', 'pjatr.com', 'senzapudore.it', 'tqlkg.net', 'xclicks.net',
				'30daychange.co', 'adocean.pl', 'allmt.com', 'c8factor.com', 'dmg-mobile.com', 'gemineering.com', 'juiceadv.net', 'moborobot.com', 'pjtra.com', 'senzapudore.net', 'traceadmanager.com', 'xcrsqg.com',
				'32b4oilo.com', 'adohana.com', 'alloydigital.com', 'callhelpmetaroll.rocks', 'dmu20vut.com', 'genericlink.com', 'jujuads.com', 'mobpartner.mobi', 'platinumadvertisement.com', 'serialbay.com', 'trackadvertising.net', 'xdev.info',
				'32d1d3b9c.se', 'adonion.com', 'allslotscasino.com', 'camleyads.info', 'dntrck.com', 'genericsteps.com', 'jujzh9va.com', 'mobstrks.com', 'play24.us', 'seriousfiles.com', 'trackcorner.com', 'xeontopa.com',
				'3393.com', 'adonly.com', 'allyes.com', 'campanja.com', 'dojerena.com', 'genesismedia.com', 'jumboaffiliates.com', 'mobtrks.com', 'playertraffic.com', 'servali.net', 'tracki112.com', 'xfs5yhr1.com',
				'350media.com', 'adonweb.ru', 'alphabird.com', 'canoeklix.com', 'dollarade.com', 'genovesetacet.com', 'jumbolt.ru', 'mobytrks.com', 'pleeko.com', 'servebom.com', 'tracking.to', 'xgraph.net',
				'360ads.com', 'adoperator.com', 'alphabirdnetwork.com', 'capacitygrid.com', 'dollarsponsor.com', 'geo-idm.fr', 'jumpelead.com', 'mocean.mobi', 'plenomedia.com', 'servedbyadbutler.com', 'tracking101.com', 'xjfjx8hw.com',
				'360adshost.net', 'adoptim.com', 'alphagodaddy.com', 'capitatmarket.com', 'domainadvertising.com', 'geoipads.com', 'jumptap.com', 'modelegating.com', 'plexop.net', 'servedbyopenx.com', 'tracking11.com', 'xmasdom.com',
				'360adstrack.com', 'adorika.com', 'alpinedrct.com', 'captainad.com', 'domainbuyingservices.com', 'geopromos.com', 'junbi-tracker.com', 'moffsets.com', 'pllddc.com', 'servemeads.com', 'trackingoffer.info', 'xmlconfig.ltassrv.com',
				'360installer.com', 'adorika.net', 'alternads.info', 'captifymedia.com', 'domainsponsor.com', 'geovisite.com', 'jursp.com', 'mogointeractive.com', 'plocap.com', 'serve-sys.com', 'trackingoffer.net', 'xplrer.co',
				'360popads.com', 'adotic.com', 'alternativeadverts.com', 'carambo.la', 'domdex.com', 'gestionpub.com', 'juruasikr.net', 'mojiva.com', 'plugerr.com', 'serving-sys.com', 'trackpath.biz', 'xs.mochiads.com',
				'360yield.com', 'adotomy.com', 'altitude-arena.com', 'carbonads.com', 'domri.net', 'getgamers.eu', 'justrelevant.com', 'mojoaffiliates.com', 'plusfind.net', 'sethads.info', 'trackpromotion.net', 'xtcie.com',
				'365sbaffiliates.com', 'adotube.com', 'am10.ru', 'careerjournalonline.com', 'doogleonduty.com', 'getgscfree.com', 'jusukrs.com', 'mokonocdn.com', 'plxserve.com', 'sev4ifmxa.com', 'trackstarsengland.net', 'xtendadvert.com',
				'3cnce854.com', 'adpacks.com', 'am11.ru', 'carrier.bz', 'dorenga.com', 'getscorecash.com', 'jwaavsze.com', 'money4ads.com', 'pmsrvr.com', 'sevenads.net', 'trackthatad.com', 'xtendmedia.com',
				'3lift.com', 'adparlor.com', 'am15.net', 'cartorkins.com', 'dotandad.com', 'getthislistbuildingvideo.biz', 'jyvtidkx.com', 'moneycosmos.com', 'pnoss.com', 'sevendaystart.com', 'tracktor.co.uk', 'xubob.com',
				'3lr67y45.com', 'adpath.mobi', 'amazon-adsystem.com', 'casalemedia.com', 'dotomi.com', 'gettipsz.info', 'k0z09okc.com', 'money-cpm.fr', 'pntra.com', 'sexitnow.com', 'trackword.net', 'xvika.com',
				'3omb.com', 'adpay.com', 'amazon-cornerstone.com', 'cash4members.com', 'double.net', 'gghfncd.net', 'kanoodle.com', 'moneytec.com', 'pntrac.com', 'sexmoney.com', 'trackyourlinks.com', 'xx00.info',
				'3rdads.com', 'adperfect.com', 'amazonily.com', 'cashatgsc.com', 'doubleclick.com', 'ggncpm.com', 'kantarmedia.com', 'moneywhisper.com', 'pntrs.com', 'shakamech.com', 'tradeexpert.net', 'xxlink.net',
				'3redlightfix.com', 'adperium.com', 'am-display.com', 'cash-duck.com', 'doubleclick.net', 'giantaffiliates.com', 'kavanga.ru', 'monkeybroker.net', 'pointclicktrack.com', 'shareasale.com', 'tradepopups.com', 'xylopologyn.com',
				'3t7euflv.com', 'adphreak.com', 'amertazy.com', 'cashmylinks.com', 'doubleclicks.me', 'gib-gib-la.com', 'keewurd.com', 'monsoonads.com', 'pointroll.com', 'sharegods.com', 'traff-advertazer.com', 'ya88s1yk.com',
				'43plc.com', 'adpinion.com', 'amgdgt.com', 'cashonvisit.com', 'doublemax.net', 'gigamega.su', 'kehalim.com', 'mookie1.com', 'points2shop.com', 'shareresults.com', 'traffboost.net', 'yabuka.com',
				'46.165.197.153^', 'adpionier.de', 'amobee.com', 'cashtrafic.com', 'doublepimp.com', 'gimiclub.com', 'kerg.net', 'mootermedia.com', 'polawrg.com', 'share-server.com', 'trafficbarads.com', 'yadomedia.com',
				'46.165.197.231^', 'adplans.info', 'ampxchange.com', 'cashtrafic.info', 'doublerads.com', 'gklmedia.com', 'ketoo.com', 'mooxar.com', 'polluxnetwork.com', 'sharethrough.com', 'trafficbroker.com', 'yambotan.ru',
				'4affiliate.net', 'adplex.media', 'anastasiasaffiliate.com', 'cashworld.biz', 'doublerecall.com', 'glical.com', 'keywordblocks.com', 'moregamers.com', 'polmontventures.com', 'shoogloonetwork.com', 'trafficfactory.biz', 'yardr.net',
				'4dsply.com', 'adplxmd.com', 'andohs.net', 'casino.betsson.com', 'doubleverify.com', 'globaladsales.com', 'kikuzip.com', 'moreplayerz.com', 'polyad.net', 'shopalyst.com', 'trafficforce.com', 'yawnedgtuis.org',
				'4e43ac9c.info', 'adppv.com', 'andomedia.com', 'casiours.com', 'down1oads.com', 'globaladv.net', 'kinley.com', 'morgdm.ru', 'polydarth.com', 'shoppingads.com', 'traffichaus.com', 'yb0t.com',
				'4uvjosuc.com', 'adpredictive.com', 'andomediagroup.com', 'caspion.com', 'downloadboutique.com', 'globalinteractive.com', 'kintokup.com', 'moselats.com', 'popads.net', 'shopzyapp.com', 'trafficjunky.net', 'ycasmd.info',
				'4wnet.com', 'adpremo.com', 'anet*.tradedoubler.com', 'casterpretic.com', 'downloadthesefile.com', 'globalsuccessclub.com', 'kioshow.com', 'movad.net', 'popadscdn.net', 'showyoursite.com', 'trafficmasterz.net', 'yceml.net',
				'50.7.243.123', 'adprofit2share.com', 'angege.com', 'castplatform.com', 'downsonglyrics.com', 'global-success-club.net', 'kiosked.com', 'mpnrs.com', 'popcash.net', 'siamzone.com', 'trafficmp.com', 'yeabble.com',
				'5362367e.info', 'adproper.info', 'annualinternetsurvey.com', 'caygh.com', 'dp25.kr', 'globaltakeoff.net', 'kitnmedia.com', 'mpression.net', 'popcpm.com', 'silence-ads.com', 'trafficrevenue.net', 'yesadsrv.com',
				'5clickcashsoftware.com', 'adprotected.com', 'anomiely.com', 'cbaazars.com', 'dpbolvw.net', 'glowdot.com', 'kjgh5o.com', 'mprezchc.com', 'popcpv.com', 'silstavo.com', 'trafficspaces.net', 'yes-messenger.com',
				'5dimes.com', 'adprovi.de', 'anonymousads.com', 'cbclickbank.com', 'dpmsrv.com', 'gmads.net', 'klikadvertising.com', 'msads.net', 'popearn.com', 'silverads.net', 'traffic-supremacy.com', 'yesnexus.com',
				'5gl1x9qc.com', 'adprs.net', 'anrdoezrs.net', 'cbclicks.com', 'dpsrexor.com', 'go2jump.org', 'kliksaya.com', 'mtagmonetizationa.com', 'popmajor.com', 'simpio.com', 'trafficswarm.com', 'yieldads.com',
				'600z.com', 'adquest3d.com', 'answered-questions.com', 'cb-content.com', 'dpstack.com', 'go2media.org', 'klikvip.com', 'mtagmonetizationb.com', 'popmarker.com', 'simpleinternetupdate.com', 'trafficsway.com', 'yieldadvert.com',
				'63.225.61.4', 'adready.com', 'anwufkjjja.com', 'cbleads.com', 'draugonda.net', 'go2speed.org', 'klipmart.com', 'mtrcss.com', 'popmyad.com', 'simply.com', 'trafficsynergy.com', 'yieldbuild.com',
				'64.20.60.123', 'adreadytractions.com', 'anymedia.lv', 'cbn.tbn.ru', 'dreamaquarium.com', 'godspeaks.net', 'klixfeed.com', 'mujap.com', 'popmyads.com', 'simplyhired.com', 'traffictrader.net', 'yieldkit.com',
				'74.117.182.77^', 'adresellers.com', 'anyxp.com', 'cc-dt.com', 'dreamsearch.or.kr', 'goember.com', 'kloapers.com', 'multiadserv.com', 'poponclick.com', 'simusangr.com', 'trafficular.com', 'yieldlab.net',
				'777seo.com', 'adrevolver.com', 'aoqneyvmaz.com', 'cdn.mobicow.com', 'drfflt.info', 'gofindmedia.net', 'klonedaset.org', 'munically.com', 'popsads.com', 'singlesexdates.com', 'trafficvance.com', 'yieldmanager.com',
				'78.138.126.253', 'adrich.cash', 'aorms.com', 'cdna.tremormedia.com', 'drowle.com', 'gogoplexer.com', 'knorex.asia', 'music-desktop.com', 'popshow.info', 'sitebrand.com', 'trafficwave.net', 'yieldmanager.net',
				'78.140.131.214^', 'adrise.de', 'aorpum.com', 'cdnads.com', 'dsero.net', 'gojoingscnow.com', 'knowd.com', 'mutary.com', 'poptarts.me', 'siteencore.com', 'trafficz.com', 'yieldmo.com',
				'7insight.com', 'adrocket.com', 'apex-ad.com', 'cdn-image.com', 'dsnextgen.com', 'goodadvert.ru', 'kolition.com', 'mxtads.com', 'popularitish.com', 'sitescout.com', 'trafficzap.com', 'yieldoptimizer.com',
				'7search.com', 'ads.sexier.com', 'apmebf.com', 'cdnrl.com', 'dsnr-affiliates.com', 'goodadvertising.info', 'komoona.com', 'myaffiliates.com', 'popularmedia.net', 'sitescoutadserver.com', 'traffirms.com', 'yieldselect.com',
				'7u8a8i88.com', 'ads01.com', 'appads.com', 'cdnservr.com', 'dsultra.com', 'googleadservicepixel.com', 'kontextua.com', 'myclickbankads.com', 'populis.com', 'sitesense-oo.com', 'trahic.ru', 'yieldtraffic.com',
				'82d914.se', 'ads2ads.net', 'appendad.com', 'centralnervous.net', 'dtmpub.com', 'googlesyndicatiion.com', 'koocash.com', 'mycooliframe.net', 'populisengage.com', 'sitethree.com', 'trapasol.com', 'yieldx.com',
				'83nsdjqqo1cau183xz.com', 'ads2srv.com', 'applebarq.com', 'cerotop.com', 'dtzads.com', 'googletagservices.com/tag/js/gpt_', 'korrelate.net', 'mydreamads.com', 'popunder.ru', 'sittiad.com', 'traveladvertising.com', 'yldbt.com',
				'888casino.com', 'ads4cheap.com', 'apportium.com', 'cgecwm.org', 'duactinor.net', 'googletagservices.com/tag/static/', 'kovla.com', 'myemailbox.info', 'popundertotal.com', 'skimlinks.com', 'travelscream.com', 'yldmgrimg.net',
				'888games.com', 'ads-4u.com', 'appr8.net', 'chango.com', 'dualmarket.info', 'gopjn.com', 'kqzyfj.com', 'myinfotopia.com', 'popunderz.com', 'skinected.com', 'travidia.com', 'yllix.com',
				'888media.net', 'adsafeprotected.com', 'apptap.com', 'chanished.net', 'dudelsa.com', 'gorgonkil.com', 'kr3vinsx.com', 'my-layer.net', 'popuptraffic.com', 'skoovyads.com', 'tredirect.com', 'ymads.com',
				'888medianetwork.com', 'adsalvo.com', 'april29-disp-download.com', 'chansiar.net', 'duetads.com', 'gotoplaymillion.com', 'kromeleta.ru', 'mylinkbox.com', 'popupvia.com', 'skyactivate.com', 'trenpyle.com', 'yobr.net',
				'888poker.com', 'adsame.com', 'apsmediaagency.com', 'charltonmedia.com', 'duggiads.com', 'gourmetads.com', 'kuad.kusogi.com', 'mynewcarquote.us', 'pornv.org', 'skyscrpr.com', 'triadmedianetwork.com', 'yoc-adserver.com',
				'888promos.com', 'adsbookie.com', 'apxlv.com', 'checkm8.com', 'dumedia.ru', 'governmenttrainingexchange.com', 'kuangard.net', 'myplayerhd.net', 'posternel.com', 'slikslik.com', 'tribalfusion.com', 'yodr.net',
				'8yxupue8.com', 'adsbrook.com', 'ar.voicefive.com', 'checkmystats.com.au', 'durnowar.com', 'goviral.hs.llnwd.net', 'kumpulblogger.com', 'mysearch-online.com', 'postrelease.com', 'slimspots.com', 'trigami.com', 'yomri.net',
				'97d73lsi.com', 'adscale.de', 'arab4eg.com', 'checkoutfree.com', 'durokuro.com', 'goviral-content.com', 'l3op.info', 'mythings.com', 'poweradvertising.co.uk', 'slimtrade.com', 'trk4.com', 'yopdi.com',
				'9d63c80da.pw', 'adscampaign.net', 'arabweb.biz', 'cherytso.com', 'durtz.com', 'gpacalculatorhighschoolfree.com', 'ladbrokesaffiliates.com.au', 'myuniques.ru', 'powerfulbusiness.net', 'slinse.com', 'trkalot.com', 'yottacash.com',
				'9newstoday.net', 'adscendmedia.com', 'arcadebannerexchange.net', 'chicbuy.info', 'dutolats.net', 'grabmyads.com', 'lakequincy.com', 'myvads.com', 'powerlinks.com', 'smaato.net', 'trkclk.net', 'youcandoitwithroi.com',
				'9ts3tpia.com', 'adsclickingnetwork.com', 'arcadebannerexchange.org', 'chinagrad.ru', 'dvaminusodin.net', 'grabo.bg', 'lakidar.net', 'mz28ismn.com', 'ppcindo.com', 'smaclick.com', 'trker.com', 'youlamedia.com',
				'a.adroll.com', 'adsdk.com', 'arcadebanners.com', 'china-netwave.com', 'dyino.com', 'grafpedia.com', 'landsraad.cc', 'n388hkxg.com', 'ppclinking.com', 'smart.allocine.fr', 'trklnks.com', 'youlouk.com',
				'a.raasnet.com', 'adsdot.ph', 'arcadebe.com', 'chipleader.com', 'dynamicoxygen.com', 'grapeshot.co.uk', 'lanistaconcepts.com', 'nabbr.com', 'ppctrck.com', 'smart2.allocine.fr', 'trks.us', 'youradexchange.com',
				'a2dfp.net', 'ads-elsevier.net', 'arcadechain.com', 'chitika.com', 'dynamitedata.com', 'gratisnetwork.com', 'largestable.com', 'nagrande.com', 'ppcwebspy.com', 'smartad.ee', 'trllxv.co', 'yourfastpaydayloans.com',
				'a2pub.com', 'adsensecamp.com', 'areasnap.com', 'chitika.net', 'e9mlrvy1.com', 'greatbranddeals.com', 'laserhairremovalstore.com', 'nanigans.com', 'ppsearcher.ru', 'smartadserver.com', 'trndi.net', 'yourquickads.com',
				'a3pub.com', 'adserv8.com', 'artbr.net', 'chiuawa.net', 'eads.to', 'greenads.org', 'launchbit.com', 'nativead.co', 'precisionclick.com', 'smartdevicemedia.com', 'trtrccl.com', 'your-tornado-file.com',
				'a433.com', 'adserve.com', 'arti-mediagroup.com', 'chronicads.com', 'eads-adserving.com', 'greenlabelppc.com', 'layer-ad.org', 'nativeads.com', 'predictad.com', 'smarterdownloads.net', 'truex.com', 'your-tornado-file.org',
				'a4dtrk.com', 'adserve.ph', 'as5000.com', 'chualangry.com', 'earnify.com', 'grenstia.com', 'layerloop.com', 'nbjmp.com', 'prestadsng.com', 'smart-feed-online.com', 'trw12.com', 'ypppdc.com',
				'a5pub.com', 'ad-server.co.za', 'asafesite.com', 'cibleclick.com', 'easyad.com', 'gretzalz.com', 'layerwelt.com', 'nbstatic.com', 'prexista.com', 'smarttargetting.co.uk', 'trygen.co.uk', 'ypprr.com',
				'aa.voice2page.com', 'adserver-fx.com', 'aseadnet.com', 'city-ads.de', 'easy-adserver.com', 'greystripe.com', 'lazynerd.info', 'ncrjsserver.com', 'prf.hn', 'smarttargetting.com', 'ttzmedia.com', 'yrrrbn.me',
				'aaa.at4.info', 'ad-serverparc.nl', 'asklots.com', 'citysite.net', 'easydownload4you.com', 'gripdownload.co', 'lbm1.com', 'neblotech.com', 'prfffc.info', 'smarttargetting.net', 'tualipoly.net', 'ytsa.net',
				'aaa.dv0.info', 'adserverplus.com', 'asooda.com', 'cjt1.net', 'easydownloadnow.com', 'grllopa.com', 'lcl2adserver.com', 'negolist.com', 'prickac.com', 'smarttds.ru', 'tubberlo.com', 'yuarth.com',
				'a-ads.com', 'adserverpub.com', 'asrety.com', 'clarityray.com', 'easyflirt-partners.biz', 'groovinads.com', 'ldgateway.com', 'neobux.com', 'primaryads.com', 'smartwebads.com', 'tubemogul.com', 'yuasaghn.com',
				'abbeyblog.me', 'adservhere.com', 'assetize.com', 'clash-media.com', 'easyhits4u.com', 'groupcommerce.com', 'lduhtrp.net', 'neodatagroup.com', 'print3.info', 'smartyads.com', 'tubereplay.com', 'yucce.com',
				'abletomeet.com', 'adservingfactory.com', 'assoc-amazon.ca', 'claxonmedia.com', 'easyinline.com', 'grt02.com', 'leadacceptor.com', 'neoffic.com', 'prizegiveaway.org', 'smileycentral.com', 'tumri.net', 'yumenetworks.com',
				'abnad.net', 'adservinginternational.com', 'assoc-amazon.co.uk', 'clayaim.com', 'easykits.org', 'grt03.com', 'leadad.mobi', 'net3media.com', 'proadsdirect.com', 'smilyes4u.com', 'turbotraff.net', 'yupfiles.net',
				'aboutads.quantcast.com', 'adservpi.com', 'assoc-amazon.com', 'cleafs.com', 'ebannertraffic.com', 'gscontxt.net', 'leadadvert.info', 'net-ad-vantage.com', 'pro-advert.de', 'smowtion.com', 'turn.com', 'yupiromo.ru',
				'absoluteclickscom.com', 'adservr.de', 'assoc-amazon.de', 'clear-request.com', 'ebayobjects.com', 'gscsystemwithdarren.com', 'leadbolt.net', 'netaffiliation.com', 'pro-advertising.com', 'smpgfx.com', 'tusno.com', 'yvoria.com',
				'abtracker.us', 'adsfac.eu', 'assoc-amazon.es', 'clente.com', 'ebayobjects.com.au', 'gsniper2.com', 'leadcola.com', 'netavenir.com', 'probannerswap.com', 'sms-mmm.com', 'tutvp.com', 'yz56lywd.com',
				'accelacomm.com', 'adsfac.net', 'assoc-amazon.fr', 'clevv.com', 'eblastengine.com', 'guardiandigitalcomparison.co.uk', 'leaderpub.fr', 'netflixalternative.net', 'prod.untd.com', 'smutty.com', 'tvas-a.pw', 'yzrnur.com',
				'access-mc.com', 'adsfac.us', 'assoc-amazon.it', 'click.scour.com', 'ebuzzing.com', 'guitaralliance.com', 'leadmediapartners.com', 'netliker.com', 'proffigurufast.com', 'sn00.net', 'tvas-b.pw', 'yzus09by.com',
				'accmgr.com', 'adsfactor.net', 'a-static.com', 'click2jump.com', 'ebz.io', 'gumgum.com', 'leetmedia.com', 'netloader.cc', 'profitpeelers.com', 'snap.com', 'tvprocessing.com', 'z4pick.com',
				'accmndtion.org', 'adsfast.com', 'asterpix.com', 'click4free.info', 'ebzkswbs78.com', 'gunpartners.com', 'legisland.net', 'netpondads.com', 'programresolver.net', 'sndkorea.co.kr', 'twalm.com', 'z5x.net',
				'accounts.pkr.com', 'adsforindians.com', 'astree.be', 'clickable.com', 'edabl.net', 'gururevenue.com', 'lesuard.com', 'netseer.com', 'projectwonderful.com', 'sochr.com', 'tweard.com', 'zangocash.com',
				'accuserveadsystem.com', 'adsfundi.com', 'atemda.com', 'clickad.pl', 'edgeads.org', 'gusufrs.me', 'letsgoshopping.tk', 'netshelter.net', 'pro-market.net', 'socialbirth.com', 'twinpinenetwork.com', 'zanox.com/ppv/',
				'acf-webmaster.net', 'adsfundi.net', 'atmalinks.com', 'clickagy.com', 'edgevertise.com', 'gwallet.com', 'letshareus.com', 'netsolads.com', 'promobenef.com', 'socialelective.com', 'twistads.com', 'zanox-affiliate.de/ppv/',
				'acronym.com', 'adsfuse.com', 'ato.mx', 'clickbet88.com', 'edomz.net', 'gx101.com', 'lfstmedia.com', 'networkplay.in', 'promo-reklama.ru', 'sociallypublish.com', 'twittad.com', 'zaparena.com',
				'actiondesk.com', 'adshack.com', 'atomex.net', 'clickbooth.com', 'eedr.org', 'h12-media.com', 'lgse.com', 'networkxi.com', 'promotionoffer.mobi', 'socialmedia.com', 'twtad.com', 'zappy.co.za',
				'activedancer.com', 'adshexa.com', 'atresadvertising.com', 'clickboothlnk.com', 'effectivemeasure.net', 'halfpriceozarks.com', 'lia-ndr.com', 'networld.hk', 'promotions.sportsbet.com.au', 'socialreach.com', 'tyroo.com', 'zapunited.com',
				'ad.atdmt.com/i/a.html', 'adshopping.com', 'atrinsic.com', 'clickbubbles.net', 'e-find.co', 'halogennetwork.com', 'liftdna.com', 'networldmedia.net', 'promotions-paradise.org', 'socialspark.com', 'u1hw38x0.com', 'zde-engage.com',
				'ad.atdmt.com/i/a.js', 'adshost1.com', 'atwola.com', 'clickcash.com', 'egamingonline.com', 'hanaprop.com', 'ligational.com', 'neudesicmediagroup.com', 'promotiontrack.mobi', 'society6.com', 'u-ad.info', 'zeads.com',
				'ad.yieldpartners.com', 'adshost2.com', 'au2m8.com', 'clickcertain.com', 'e-generator.com', 'hapnr.net', 'ligatus.com', 'newdosug.eu', 'propellerads.com', 'sociocast.com', 'ubudigital.com', 'zedo.com',
				'ad120m.com', 'adshostnet.com', 'auctionnudge.com', 'clickequations.net', 'ekmas.com', 'happilyswitching.net', 'lightad.co.kr', 'newgentraffic.com', 'propellerpops.com', 'sociomantic.com', 'udmserve.net', 'zeesiti.com',
				'ad121m.com', 'adshot.de', 'audience2media.com', 'clickexa.com', 'ektezis.ru', 'harrenmedianetwork.com', 'lightningcast.net', 'newideasdaily.com', 'propelplus.com', 'sodud.com', 'ugaral.com', 'zenoviaexchange.com',
				'ad122m.com', 'adshuffle.com', 'audiencefuel.com', 'clickexperts.net', 'elasticad.net', 'havamedia.net', 'linicom.co.il', 'newsadstream.com', 'prosperent.com', 'so-excited.com', 'ughus.com', 'zenoviagroup.com',
				'ad123m.com', 'adsignals.com', 'audienceprofiler.com', 'clickfuse.com', 'electnext.com', 'havetohave.com', 'linkbuddies.com', 'newsnet.in.ua', 'protally.net', 'soft4dle.com', 'uglyst.com', 'zercstas.com',
				'ad125m.com', 'adsimilis.com', 'auditude.com', 'clickintext.com', 'elefantsearch.com', 'havnr.com', 'linkclicks.com', 'newstogram.com', 'prowlerz.com', 'softonicads.com', 'uiadserver.com', 'zerezas.com',
				'ad127m.com', 'adsinimages.com', 'augmentad.net', 'clickintext.net', 'elepheny.com', 'hb-247.com', 'linkconnector.com', 'newtention.net', 'proximic.com', 'softpopads.com', 'uiqatnpooq.com', 'zferral.com',
				'ad128m.com', 'adskeeper.co.uk', 'aunmdhxrco.com', 'clickkingdom.net', 'elvate.net', 'hdplayer-download.com', 'linkelevator.com', 'nexac.com', 'prre.ru', 'softwares2015.com', 'ukbanners.com', 'zidae.com',
				'ad129m.com', 'adslidango.com', 'auspipe.com', 'clickmngr.com', 'emberads.com', 'hd-plugin.com', 'linkexchange.com', 'nexage.com', 'psclicks.com', 'sokitosa.com', 'unanimis.co.uk', 'ziffdavis.com',
				'ad131m.com', 'adslingers.com', 'auto-im.com', 'clickmyads.info', 'emediate.ch', 'hdvidcodecs.com', 'linkexchangers.net', 'nextmobilecash.com', 'pseqcs05.com', 'solapoka.com', 'underclick.ru', 'zipropyl.com',
				'ad132m.com', 'adslot.com', 'auto-insurance-quotes-compare.com', 'clicknano.com', 'emediate.dk', 'hdvid-codecs-dl.net', 'linkgrand.com', 'ngecity.com', 'ptmzr.com', 'solarmosa.com', 'undertone.com', 'znaptag.com',
				'ad134m.com', 'adsmarket.com', 'automatedtraffic.com', 'clickosmedia.com', 'emediate.eu', 'headup.com', 'linkmads.com', 'nicheadgenerator.com', 'ptp.lolco.net', 'solocpm.com', 'unicast.com', 'zoglafi.info',
				'ad20.net', 'adsmarket.es', 'automateyourlist.com', 'clicks2count.com', 'emediate.se', 'healthaffiliatesnetwork.com', 'linkoffers.net', 'nicheads.com', 'ptp22.com', 'solutionzip.info', 'unitethecows.com', 'zompmedia.com',
				'ad2387.com', 'adsmedia.cc', 'avads.co.uk', 'clicksor.com', 'emjcd.com', 'healthcarestars.com', 'linkreferral.com', 'nighter.club', 'ptp24.com', 'sonnerie.net', 'universityofinternetscience.com', 'zomri.net',
				'ad2adnetwork.biz', 'adsmile.biz', 'avalanchers.com', 'clicksor.net', 'empiremoney.com', 'hebiichigo.com', 'links.io', 'nkredir.com', 'pubdirecte.com', 'sonobi.com', 'unlockr.com', 'zonealta.com',
				'ad2games.com', 'adsmoon.com', 'avazu.net', 'clicksurvey.mobi', 'employers-freshly.org', 'heizuanubr.net', 'linkshowoff.com', 'nmcdn.us', 'pub-fit.com', 'sophiasearch.com', 'unrulymedia.com', 'zonplug.com',
				'ad2up.com', 'adsmws.cloudapp.net', 'avazutracking.net', 'clicksvenue.com', 'emptyspaceads.com', 'helloreverb.com', 'linksmart.com', 'nmwrdr.net', 'pubgears.com', 'sparkstudios.com', 'unterary.com', 'zoomdirect.com.au',
				'ad4game.com', 'adsnative.com', 'avercarto.com', 'clickter.net', 'engineseeker.com', 'hexagram.com', 'linkstorm.net', 'nobleppc.com', 'publicidad.net', 'specificclick.net', 'unuarvse.net', 'zrfrornn.net',
				'ad6media.fr', 'adsnetworkserver.com', 'awaps.net', 'clickthrucash.com', 'enlnks.com', 'hiadone.com', 'linksynergy.com', 'nobsetfinvestor.com', 'publicidees.com', 'specificmedia.com', 'upads.info', 'zugo.com',
				'adacado.com', 'adsnext.net', 'awempire.com', 'clickupto.com', 'enterads.com', 'highcpms.com', 'linkwash.de', 'nonstoppartner.de', 'publicityclerks.com', 'spectato.com', 'updater-checker.net', 'zwaar.org',
				'adaction.se', 'adsniper.ru', 'awin1.com', 'clickwinks.com', 'entrecard.com', 'hijacksystem.com', 'linkworth.com', 'noretia.com', 'publisher.to', 'speeb.com', 'upliftsearch.com', 'zxxds.net',
				'adadvisor.net', 'adsonar.com', 'awltovhc.com', 'clickxchange.com', 'entrecard.s3.amazonaws.com', 'hilltopads.net', 'linkybank.com', 'normkela.com', 'publisheradnetwork.com', 'speedshiftmedia.com', 'uppo.co', 'zypenetwork.com',
				'adagora.com', 'adsopx.com', 'awsclic.com', 'clixgalore.com', 'entru.co', 'h-images.net', 'linkz.net', 'northmay.com', 'pubmatic.com', 'speedsuccess.net', 'urbation.net',
				'adaos-ads.net', 'adsovo.com', 'awsmer.com', 'clixsense.com', 'eosads.com', 'himediads.com', 'liqwid.net', 'nowlooking.net', 'pubmine.com', 'spereminf.com', 'ureace.com',
				'adap.tv', 'adspaper.org', 'awsurveys.com', 'clixtrac.com', 'epicgameads.com', 'himediadx.com', 'lirte.org', 'nowspots.com', 'pubserve.net', 'spiderhood.net', 'urlads.net',
				'adapd.com', 'adspdbl.com', 'axill.com', 'clkads.com', 'e-planning.net', 'hiplair.com', 'listingcafe.com', 'nplexmedia.com', 'pubted.com', 'spinbox.freedom.com', 'urlcash.net',
				'ad-back.net', 'adspeed.com', 'ayboll.com', 'clkmon.com', 'epnredirect.ru', 'hit-now.com', 'liveadexchanger.com', 'npvos.com', 'puhtml.com', 'spinbox.net', 'usbanners.com',
				'ad-balancer.net', 'adspirit.de', 'azads.com', 'clkrev.com', 'eptord.com', 'hits.sys.lv', 'liveadoptimizer.com', 'nquchhfyex.com', 'pulse360.com', 'splazards.com', 'usemax.de',
				'adbard.net', 'ad-sponsor.com', 'azjmp.com', 'clkrev.com^', 'eptum.com', 'hobri.net', 'liveadserver.net', 'nrfort.com', 'pulsemgr.com', 'splinky.com', 'usenetjunction.com',
				'adbasket.net', 'adspring.to', 'azoogleads.com', 'clnk.me', 'eqads.com', 'hokaybo.com', 'livechatflirt.com', 'nrnma.com', 'purpleflag.net', 'splut.com', 'usenetpassport.com',
				'ad-bay.com', 'adspruce.com', 'azorbe.com', 'cloudtracked.com', 'erado.org', 'holidaytravelguide.org', 'livepromotools.com', 'nscontext.com', 'push2check.com', 'spmxs.com', 'usercash.com',
				'adblade.com', 'adspynet.com', 'b117f8da23446a91387efea0e428392a.pl', 'cltomedia.info', 'erendri.com', 'holmgard.link', 'liverail.com', 'nsdsvc.com', 'pxl2015x1.com', 'spoa-soard.com', 'usurv.com',
				'adbma.com', 'adsrevenue.net', 'b6508157d.website', 'clz3.net', 'ergers.net', 'homecareerforyou1.info', 'liversely.net', 'nsmartad.com', 'pxlad.io', 'spongecell.com', 'utarget.co.uk',
				'adboost.com', 'adsring.com', 'babbnrs.com', 'cmfads.com', 'ergerww.net', 'hopfeed.com', 'liveuniversenetwork.com', 'nspmotion.com', 'pzaasocba.com', 'sponsoredby.me', 'utarget.ru',
				'adbooth.net', 'ad-srv.net', 'backbeatmedia.com', 'cmllk1.info', 'ergodob.ru', 'hoppr.co', 'lmebxwbsno.com', 'ntent.com', 'pzuwqncdai.com', 'sponsoredtweets.com', 'utokapa.com',
				'adbrau.com', 'adsrv.us', 'backlinks.com', 'cmllk2.info', 'ero-advertising.com', 'hoptopboy.com', 'lnkgt.com', 'nturveev.com', 'q1media.com', 'sponsormob.com', 'utubeconverter.com',
				'adbrite.com', 'adsrvmedia.com', 'badjocks.com', 'cnt.my', 'eroanalysis.com', 'hornygirlsexposed.com', 'loading-resource.com', 'ntv.io', 'q1mediahydraplatform.com', 'sponsorpalace.com', 'v.fwmrm.net^',
				'adbroo.com', 'adsrvmedia.net', 'baldiro.de', 'cntdy.mobi', 'erovation.com', 'horse-racing-affiliate-program.co.uk', 'localadbuy.com', 'nuaknamg.net', 'q1xyxm89.com', 'sponsorpay.com', 'v.movad.de',
				'adbuddiz.com', 'adsrvr.org', 'bananaflippy.com', 'coadvertise.com', 'erovinmo.com', 'horsered.com', 'localedgemedia.com', 'numberium.com', 'q3sift.com', 'sponsorselect.com', 'v11media.com',
				'adbull.com', 'adssites.net', 'bannerbank.ru', 'coaterhand.net', 'ershgrst.com', 'horyzon-media.com', 'localsearch24.co.uk', 'nuseek.com', 'qadserve.com', 'sportsyndicator.com', 'v2cigs.com',
				'adbureau.net', 'ads-stats.com', 'bannerblasters.com', 'codezap.com', 'escalatenetwork.com', 'hosticanaffiliate.com', 'lockhosts.com', 'nvadn.com', 'qadservice.com', 'spotrails.com', 'v2mlblack.biz',
				'adbutler.com', 'adstatic.com', 'bannerbridge.net', 'codigobarras.net', 'escale.to', 'hotchatdirect.com', 'logo-net.co.uk', 'nvero.net', 'qdmil.com', 'spotscenered.info', 'v8bridge.link',
				'adbuyer.com', 'adsterra.com', 'bannercde.com', 'coedmediagroup.com', 'especifican.com', 'hotelscombined.com', 'loodyas.com', 'nwfhalifax.com', 'qewa33a.com', 'spottt.com', 'vadpay.com',
				'adcade.com', 'ad-stir.com', 'banner-clix.com', 'cogocast.net', 'essayads.com', 'hotelscombined.com.au', 'lookit-quick.com', 'nxtck.com', 'qksrv.net', 'spotxchange.com', 'validclick.com',
				'adcash.com', 'adsummos.net', 'bannerconnect.com', 'cogsdigital.com', 'essaycoupons.com', 'hotfeed.net', 'looksmart.com', 'nyadmcncserve-05y06a.com', 'qksz.net', 'sprintrade.com', 'valuead.com',
				'adcastplus.net', 'adsupermarket.com', 'bannerconnect.net', 'coguan.com', 'esults.net', 'hot-hits.us', 'looneyads.com', 'nymphdate.com', 'qnrzmapdcc.com', 'sproose.com', 'valueaffiliate.net',
				'adcde.com', 'adsupply.com', 'bannerdealer.com', 'coinadvert.net', 'etargetnet.com', 'hotkeys.com', 'looneynetwork.com', 'nzads.net.nz', 'qnsr.com', 'sq2trk2.com', 'valueclick.com',
				'adcdnx.com', 'adsupplyads.com', 'bannerexchange.com.au', 'collection-day.com', 'etgdta.com', 'hotptp.com', 'loopr.co', 'nzphoenix.com', 'qservz.com', 'srtk.net', 'valueclick.net',
				'adcentriconline.com', 'adsurve.com', 'bannerflow.com', 'collective-media.net', 'etmanly.ru', 'hotwords.com', 'lose-ads.de', 'o333o.com', 'quantumads.com', 'srv2trking.com', 'valueclickmedia.com',
				'adcfrthyo.tk', 'adsvert.com', 'bannerflux.com', 'colliersads.com', 'etology.com', 'hotwords.com.br', 'loseads.eu', 'oads.co', 'quensillo.com', 'srv-ad.com', 'valuecommerce.com',
				'adchap.com', 'adswizz.com', 'bannerignition.co.za', 'comclick.com', 'eurew.com', 'hotwords.com.mx', 'losomy.com', 'oainternetservices.com', 'questionmarket.com', 'srvpub.com', 'valuecontent.net',
				'adchemical.com', 'adsxgm.com', 'bannerjammers.com', 'commission.bz', 'euroclick.com', 'hover.in', 'lotteryaffiliates.com', 'obesw.com', 'questus.com', 'srx.com.sg', 'vapedia.com',
				'adchoice.co.za', 'adsymptotic.com', 'bannerlot.com', 'commissionfactory.com.au', 'euromillionairesystem.me', 'hplose.de', 'love-banner.com', 'obeus.com', 'quickcash500.com', 'sta-ads.com', 'vcmedia.com',
				'adclick.lv', 'adtaily.com', 'bannerperformance.net', 'commission-junction.com', 'europacash.com', 'hstpnetwork.com', 'loxtk.com', 'obibanners.com', 'quinstreet.com', 'stackadapt.com', 'vcommission.com',
				'adclick.pk', 'adtaily.eu', 'bannerrage.com', 'commissionlounge.com', 'euros4click.de', 'httpool.com', 'lqcdn.com', 'objects.tremormedia.com', 'qwobl.net', 'stackattacka.com', 'vdopia.com',
				'adclickafrica.com', 'adtaily.pl', 'banner-rotation.com', 'commissionmonster.com', 'e-viral.com', 'httpsecurity.org', 'lqw.me', 'objectservers.com', 'qwzmje9w.com', 'stalesplit.com', 'vectorstock.com',
				'adclickmedia.com', 'adtdp.com', 'bannersmania.com', 'completecarrd.com', 'evolvemediallc.com', 'huzonico.com', 'ltassrv.com.s3.amazonaws.com', 'oceanwebcraft.com', 'qzsccm.com', 'standartads.com', 'vellde.com',
				'ad-clicks.com', 'adtecc.com', 'bannersnack.com', 'compoter.net', 'evolvenation.com', 'hype-ads.com', 'ltassrv.com/goads.swf', 'oclasrv.com', 'r3seek.com', 'star-advertising.com', 'velmedia.net',
				'adcloud.net', 'adtech.de', 'bannersnack.net', 'comscore.com', 'ewebse.com', 'hypeads.org', 'ltassrv.com/serve/', 'oclsasrv.com', 'rabilitan.com', 'stargamesaffiliate.com', 'velti.com',
				'adcolo.com', 'adtechus.com', 'bannersurvey.biz', 'conduit-banners.com', 'exactdrive.com', 'hypemakers.net', 'luadcik.com', 'oclus.com', 'radeant.com', 'starlayer.com', 'vemba.com',
				'adcolony.com', 'adtegrity.net', 'bannertgt.com', 'connatix.com', 'exactly0r.com', 'hyperlinksecure.com', 'lucidmedia.com', 'oehposan.com', 'radicalwealthformula.com', 'startappexchange.com', 'vendexo.com',
				'adconscious.com', 'adteractive.com', 'bannertracker-script.com', 'connectedads.net', 'excellenceads.com', 'hypertrackeraff.com', 'luminate.com', 'offeradvertising.biz', 'radiusmarketing.com', 'startpagea.com', 'veoxa.com',
				'adcount.in', 'adtgs.com', 'bannerweb.com', 'connectionads.com', 'exchange4media.com', 'hypervre.com', 'lushcrush.com', 'offerforge.com', 'raiggy.com', 'statcamp.net', 'versahq.com',
				'adcron.com', 'adtlgc.com', 'baordrid.com', 'connexity.net', 'exciliburn.com', 'hyperwebads.com', 'luxadv.com', 'offerpalads.com', 'rainbowtgx.com', 'statelead.com', 'versetime.com',
				'adcru.com', 'adtoadd.com', 'baronsoffers.com', 'connexplace.com', 'excolobar.com', 'i.skimresources.com', 'luxbetaffiliates.com.au', 'offerserve.com', 'rainwealth.com', 'statsmobi.com', 'vgsgaming-ads.com',
				'addaim.com', 'adtoll.com', 'batarsur.com', 'connextra.com', 'exernala.com', 'iamediaserve.com', 'luxup.ru', 'offersquared.com', 'rampanel.com', 'statstrackeronline.com', 'vhmnetwork.com',
				'addelive.com', 'adtology1.com', 'baungarnr.com', 'construment.com', 'exitexplosion.com', 'iasbetaffiliates.com', 'lx2rv.com', 'ofino.ru', 'raoplenort.biz', 'stealthlockers.com', 'vianadserver.com',
				'ad-delivery.net', 'adtology2.com', 'baypops.com', 'consumergenepool.com', 'exitjunction.com', 'iasrv.com', 'lzjl.com', 'oggifinogi.com', 'rapt.com', 'stepkeydo.com', 'vibrant.co',
				'addiply.com', 'adtology3.com', 'bbelements.com', 'contadd.com', 'exlpor.com', 'ibannerexchange.com', 'm1.fwmrm.net^', 'ohmcasting.com', 'ratari.ru', 'stickyadstv.com', 'vibrantmedia.com',
				'addoer.com', 'adtoma.com', 'beaconads.com', 'contaxe.com', 'exoclick.com', 'ibatom.com', 'm2pub.com', 'oldtiger.net', 'rateaccept.net', 'stocker.bonnint.net', 'video1404.info',
				'addo-mnton.com', 'adtomafusion.com', 'beatchucknorris.com', 'content.ad', 'exponential.com', 'ibryte.com', 'm4pub.com', 'omclick.com', 'rawasy.com', 'streamate.com', 'videoadex.com',
				'addroid.com', 'adtoox.com', 'bebi.com', 'contentabc.com', 'expresswebtraffic.com', 'icdirect.com', 'm57ku6sm.com', 'omg2.com', 'rbnt.org', 'streamdownloadonline.com', 'videoclick.ru',
				'addynamics.eu', 'adtotal.pl', 'becoquin.com', 'contentclick.co.uk', 'extonsuan.com', 'icqadvnew.com', 'm5prod.net', 'omgpm.com', 'rcads.net', 'strikead.com', 'videodeals.com',
				'addynamix.com', 'adtpix.com', 'becoquins.net', 'content-cooperation.com', 'extra33.com', 'idealmedia.com', 'mabirol.com', 'omguk.com', 'rcurn.com', 'struq.com', 'videoegg.com',
				'addynamo.net', 'adtrace.org', 'beead.co.uk', 'contentdigital.info', 'eyere.com', 'identads.com', 'madadsmedia.com', 'omni-ads.com', 'rddywd.com', 'style-eyes.eu', 'videohub.com',
				'adecn.com', 'adtraffic.org', 'beead.net', 'contentjs.com', 'eyereturn.com', 'idownloadgalore.com', 'mad-adz.com', 'onad.eu', 'rdige.com', 'sublimemedia.net', 'videohube.eu',
				'adedy.com', 'adtransfer.net', 'beforescence.com', 'contentolyze.net', 'eyeviewads.com', 'ifilez.org', 'madserving.com', 'onads.com', 'rdsrv.com', 'submitexpress.co.uk', 'videolansoftware.com',
				'adelement.com', 'adtrgt.com', 'begun.ru', 'contentr.net', 'eyewond.hs.llnwd.net', 'iframe.mediaplazza.com', 'madsone.com', 'onclickads.net', 'reachjunction.com', 'successfultogether.co.uk', 'videoliver.com',
				'ademails.com', 'adtrix.com', 'belointeractive.com', 'contenture.com', 'eyewonder.com', 'igameunion.com', 'magicalled.info', 'onedmp.com', 'reachlocal.com', 'suggesttool.com', 'video-loader.com',
				'adengage.com', 'adtrovert.com', 'belvertising.be', 'contentwidgets.net', 'ezadserver.net', 'igloohq.com', 'magnetisemedia.com', 'onenetworkdirect.com', 'reachmode.com', 'suite6ixty6ix.com', 'videologygroup.com',
				'adespresso.com', 'adtruism.com', 'bentdownload.com', 'contexlink.se', 'ezdownloadpro.info', 'ignitioninstaller.com', 'mainadv.com', 'onenetworkdirect.net', 'reactx.com', 'suitesmart.com', 'videoplaza.com',
				'adexcite.com', 'adtwirl.com', 'bepolite.eu', 'c-on-text.com', 'ezmob.com', 'ignup.com', 'mainroll.com', 'onespot.com', 'readserver.net', 'sumarketing.co.uk', 'videoplaza.tv',
				'adexprt.com', 'aduacni.com', 'beringmedia.com', 'contextads.net', 'ezoic.net', 'iiasdomk1m9812m4z3.com', 'makecashtakingsurveys.biz', 'onhitads.net', 'realclick.co.kr', 'sunmedia.net', 'videoplaza.tv/proxy/distributor',
				'adexprts.com', 'adult-adv.com', 'bestcasinopartner.com', 'contextuads.com', 'faggrim.com', 'ilividnewtab.com', 'makemoneymakemoney.net', 'online-adnetwork.com', 'realmatch.com', 'suparewards.com', 'videovfr.com',
				'adextent.com', 'adultadworld.com', 'bestdeals.ws', 'contextweb.com', 'fairadsnetwork.com', 'imasdk.googleapis.com', 'mallsponsor.com', 'onlineadtracker.co.uk', 'realmedia.com', 'super-links.net', 'vidpay.com',
				'adf01.net', 'adultimate.net', 'bestfindsite.com', 'coolerads.com', 'falkag.net', 'imedia.co.il', 'mangoforex.com', 'onlinecareerpackage.com', 'realsecuredredir.com', 'superloofy.com', 'viedeo2k.tv',
				'adfactory88.com', 'adulttds.com', 'bestforexpartners.com', 'coolmirage.com', 'fast2earn.com', 'i-media.co.nz', 'maningrs.com', 'onlinecashmethod.com', 'realsecuredredirect.com', 'supersitetime.com', 'view.atdmt.com',
				'adfarm.mediaplex.com', 'adurr.com', 'bestgameads.com', 'copacet.com', 'fastapi.net', 'imediaaudiences.com', 'marbil24.co.za', 'onlinedl.info', 'realvu.net', 'supplyframe.com', 'viewablemedia.net',
				'ad-feeds.com', 'adv9.net', 'besthitsnow.com', 'coretarget.co.uk', 'fastates.net', 'imediarevenue.com', 'marfeel.com', 'online-media24.de', 'reate.info', 'supremeadsonline.com', 'view-ads.de',
				'adfeedstrk.com', 'adv-adserver.com', 'bestofferdirect.com', 'cor-natty.com', 'fastclick.net', 'imgfeedget.com', 'marketbanker.com', 'onlyalad.net', 'recomendedsite.com', 'surf-bar-traffic.com', 'viewclc.com',
				'ad-flow.com', 'advanseads.com', 'bestonlinecoupons.com', 'cornflip.com', 'fasttracktech.biz', 'img-giganto.net', 'marketfly.net', 'onrampadvertising.com', 'redcourtside.com', 'surveyend.com', 'viewex.co.uk',
				'adfootprints.com', 'advantageglobalmarketing.com', 'bestproducttesters.com', 'coull.com', 'faunsts.me', 'imglt.com', 'markethealth.com', 'onscroll.com', 'redintelligence.net', 'survey-poll.com', 'viewivo.com',
				'adforgames.com', 'advard.com', 'bet3000partners.com', 'coupon2buy.com', 'fbgdc.com', 'imgsniper.com', 'marketingenhanced.com', 'onsitemarketplace.net', 'reduxmediagroup.com', 'surveysforgifts.org', 'viewscout.com',
				'adforgeinc.com', 'advatar.to', 'bet365affiliates.com', 'covertarget.com^*_*.php', 'fb-plus.com', 'imgwebfeed.com', 'marketleverage.com', 'onvertise.com', 'reelcentric.com', 'surveyspaid.com', 'vindicosuite.com',
				'adform.net', 'adventori.com', 'betaffs.com', 'cpabeyond.com', 'fbsvu.com', 'imho.ru', 'marketnetwork.com', 'oodode.com', 'refban.com', 'surveystope.com', 'vipcpms.com',
				'adframesrc.com', 'adversal.com', 'betoga.com', 'cpaclicks.com', 'featuredusers.com', 'imiclk.com', 'marketoring.com', 'ooecyaauiz.com', 'referback.com', 'surveyvalue.mobi', 'vipquesting.com',
				'adfrika.com', 'adversaldisplay.com', 'betrad.com', 'cpaclickz.com', 'featurelink.com', 'imonomy.com', 'marketresearchglobal.com', 'oofte.com', 'regdfh.info', 'surveyvalue.net', 'viralmediatech.com',
				'adfrog.info', 'adversalservers.com', 'bettingpartners.com', 'cpagrip.com', 'feed-ads.com', 'imp*.tradedoubler.com', 'marsads.com', 'oos4l.com', 'regersd.net', 'surveywidget.biz', 'visiads.com',
				'adfrontiers.com', 'adverserve.net', 'bfast.com', 'cpalead.com', 'feljack.com', 'impact-ad.jp', 'martiniadnetwork.com', 'opap.co.kr', 'registry.cw.cm', 'suthome.com', 'visiblegains.com',
				'adfunkyserver.com', 'advertarium.com.ua', 'bh3.net', 'cpalock.com', 'fenixm.com', 'impactradius.com', 'masterads.org', 'openadserving.com', 'regurgical.com', 'svlu.net', 'visiblemeasures.com',
				'adfusion.com', 'advertbox.us', 'biankord.net', 'cpanuk.com', 'f-hookups.com', 'implix.com', 'masternal.com', 'openbook.net', 'rehok.km.ua', 'swadvertising.org', 'visitdetails.com',
				'adgalax.com', 'adverteerdirect.nl', 'biastoful.net', 'cpaway.com', 'fhserve.com', 'impresionesweb.com', 'mastertraffic.cn', 'open-downloads.net', 'reklamz.com', 'swbdds.com', 'visitweb.com',
				'adgardener.com', 'adverticum.net', 'bidgewatr.com', 'cpays.com', 'fidel.to', 'impressionaffiliate.com', 'matiro.com', 'openetray.com', 'relatedweboffers.com', 'swelen.com', 'visualsteel.net',
				'adgatemedia.com', 'advertise.com', 'bidsystem.com', 'cpcadnet.com', 'filestube.com', 'impressionaffiliate.mobi', 'maudau.com', 'opensourceadvertisementnetwork.info', 'relestar.com', 'switchadhub.com', 'vitalads.net',
				'ad-gbn.com', 'advertiseforfree.co.za', 'bidvertiser.com', 'cpfclassifieds.com', 'filetarget.com', 'impressioncontent.info', 'maxserving.com', 'openxadexchange.com', 'relevanti.com', 'swoop.com', 'vivamob.net',
				'adgear.com', 'advertisegame.com', 'biemedia.com', 'c-planet.net', 'filtermomosearch.com', 'impressiondesk.com', 'mb01.com', 'openxenterprise.com', 'relytec.com', 'sxrrxa.net', 'vntsm.com',
				'adgebra.co.in', 'advertisespace.com', 'bigadpoint.net', 'cpm.biz', 'fimserve.com', 'impressionperformance.biz', 'mb102.com', 'openxmarket.asia', 'remiroyal.ro', 'symbiosting.com', 'vogosita.com',
				'adgent007.com', 'advertiseyourgame.com', 'bigfineads.com', 'cpmadvisors.com', 'finalanypar.link', 'impressionvalue.mobi', 'mb104.com', 'operatical.com', 'reporo.net', 'symkashop.ru', 'vogozaw.ru',
				'adgila.com', 'advertising.com', 'bighot.ru', 'cpmaffiliation.com', 'finance-reporting.org', 'in-appadvertising.com', 'mb38.com', 'oplo.org', 'resideral.com', 'syncedvision.com', 'vopdi.com',
				'adgine.net', 'advertising365.com', 'bijscode.com', 'cpmleader.com', 'find-abc.com', 'inbinaryoption.com', 'mb57.com', 'opner.co', 'respecific.net', 'syndicatedsearchresults.com', 'vpico.com',
				'adgitize.com', 'advertising-department.com', 'bimlocal.com', 'cpmmedia.net', 'findbestsolution.net', 'incentaclick.com', 'mbn.com.ua', 'opteama.com', 'respond-adserver.cloudapp.net', 't3q7af0z.com', 'vprmnwbskk.com',
				'adglamour.net', 'advertisingiq.com', 'binaryoptionsgame.com', 'cpmrocket.com', 'find-cheap-hotels.org', 'incomeliberation.com', 'mcdomainalot.com', 'optiad.net', 'respondhq.com', 't3sort.com', 'vs20060817.com',
				'adgorithms.com', 'advertisingpath.net', 'binaryoptionssystems.org', 'cpmstar.com', 'findonlinesurveysforcash.com', 'increase-marketing.com', 'mcdstorage.com', 'optimalroi.info', 'resultlinks.com', 't7row.com', 'vs4entertainment.com',
				'adgoto.com', 'advertisingvalue.info', 'bingo4affiliates.com', 'cpmterra.com', 'findsthat.com', 'indexww.com', 'mdadvertising.net', 'optimatic.com', 'resultsz.com', 'tacastas.com', 'vs4family.com',
				'adgroups.com', 'advertjunction.com', 'binlayer.com', 'cpmtree.com', 'firaxtech.com', 'indiabanner.com', 'mdialog.com', 'optimizeadvert.biz', 'retargeter.com', 'tacoda.net', 'vsservers.net',
				'adgrx.com', 'advertlead.net', 'binlayer.de', 'cpuim.com', 'firefeeder.com', 'indiads.com', 'mdn2015x1.com', 'optinemailpro.com', 'retkow.com', 'tacticalrepublic.com', 'vth05dse.com',
				'adhese.be', 'advertlets.com', 'bin-layer.de', 'cpulaptop.com', 'firegob.com', 'indianbannerexchange.com', 'mdn2015x2.com', 'opt-intelligence.com', 'reussissonsensemble.fr', 'tafmaster.com', 'vuiads.de',
				'adhese.com', 'advertmarketing.com', 'bin-layer.ru', 'cpvads.com', 'firmharborlinked.com', 'indianlinkexchange.com', 'mdn2015x4.com', 'opt-n.net', 'rev2pub.com', 'taggify.net', 'vuiads.info',
				'adhese.net', 'advertmedias.com', 'bitads.net', 'cpvadvertise.com', 'firstadsolution.com', 'indianweeklynews.com', 'meadigital.com', 'orangeads.fr', 'revcontent.com', 'tagjunction.com', 'vuiads.net',
				'adhitzads.com', 'advertpay.net', 'bitcoinadvertisers.com', 'cpvmarketplace.info', 'firstclass-download.com', 'indicate.to', 'media.net', 'orarala.com', 'revenue.com', 'tagshost.com', 'vungle.com',
				'adhood.com', 'advertrev.com', 'bitfalcon.tv', 'cpvtgt.com', 'firstimpression.io', 'indieclick.com', 'media303.com', 'orbengine.com', 'revenuegiants.com', 'tailsweep.com', 'w00tads.com',
				'adhostingsolutions.com', 'advertserve.com', 'bittads.com', 'cpx24.com', 'firstlightera.com', 'indofad.com', 'media6degrees.com', 'oskale.ru', 'revenuehits.com', 'takensparks.com', 'w00tmedia.net',
				'adhub.co.nz', 'advertstatic.com', 'bitx.tv', 'cpxadroit.com', 'firstmediahub.com', 'industrybrains.com', 'media970.com', 'ospreymedialp.com', 'revenuemantra.com', 'talaropa.com', 'w3exit.com',
				'adicate.com', 'advertstream.com', 'bizographics.com', 'cpxinteractive.com', 'first-rate.com', 'inentasky.com', 'mediaadserver.org', 'othersonline.com', 'revenuemax.de', 'tangozebra.com', 'w4.com',
				'adigniter.org', 'advertur.ru', 'bizrotator.com', 'crakmedia.com', 'fisari.com', 'inetinteractive.com', 'media-app.com', 'ourunlimitedleads.com', 'revfusion.net', 'tapad.com', 'w4statistics.info',
				'adikteev.com', 'advertxi.com', 'bizzclick.com', 'crazyad.net', 'fixionmedia.com', 'infectiousmedia.com', 'mediaclick.com', 'oveld.com', 'revmob.com', 'tapjoyads.com', 'w5statistics.info',
				'adimise.com', 'advg.jp', 'blamads.com', 'crazylead.com', 'fl-ads.com', 'infinite-ads.com', 'mediacpm.com', 'overhaps.com', 'revokinets.com', 'tardangro.com', 'w9statistics.info',
				'adimpact.com', 'advgoogle.com', 'blamcity.com', 'crazyvideosempire.com', 'flagads.net', 'infinityads.com', 'mediaffiliation.com', 'overture.com', 'revresda.com', 'targetadverts.com', 'waddr.com',
				'adimperia.com', 'ad-vice.biz', 'blardenso.com', 'creative-serving.com', 'flashclicks.com', 'influads.com', 'mediaflire.com', 'overturs.com', 'revresponse.com', 'targetnet.com', 'wafmedia5.com',
				'adimpression.net', 'adviva.net', 'blazwuatr.com', 'creditcards15x.tk', 'flashtalking.com', 'info4.a7.org', 'mediaforge.com', 'oxado.com', 'revsci.net', 'targetpoint.com', 'waframedia3.com',
				'adimps.com', 'advmd.com', 'blinkadr.com', 'crhikay.me', 'flaudnrs.me', 'infolinks.com', 'mediag4.com', 'oxsng.com', 'rewardisement.com', 'targetspot.com', 'wagershare.com',
				'adinch.com', 'advmedialtd.com', 'blinko.es', 'crispads.com', 'flaurse.net', 'information-sale.com', 'media-general.com', 'oxtracking.com', 'rewardsaffiliates.com', 'tattomedia.com', 'wahoha.com',
				'adincon.com', 'advombat.ru', 'blinkogold.es', 'criteo.com', 'fliionos.co.uk', 'infra-ad.com', 'mediagridwork.com', 'oxybe.com', 'rewardstyle.com', 'tbaffiliate.com', 'wamnetwork.com',
				'ad-indicator.com', 'advpoints.com', 'blipi.net', 'criteo.net', 'flite.com', 'inktad.com', 'mediakeywords.com', 'ozertesa.com', 'rfihub.net', 'tcadops.ca', 'wangfenxi.com',
				'adindigo.com', 'advrtice.com', 'blockthis.es', 'crossrider.com', 'fllwert.net', 'inmobi.com', 'media-ks.net', 'ozonemedia.com', 'rgadvert.com', 'td553.com', 'wapdollar.in',
				'adinfinity.com.au', 'advsnx.net', 'blogads.com', 'crowdgatheradnetwork.com', 'flodonas.com', 'innity.com', 'medialand.ru', 'p2ads.com', 'rhgersf.com', 'teads.tv', 'waptrick.com',
				'adinterax.com', 'advuatianf.com', 'blogbannerexchange.com', 'crowdgravity.com', 'fluidads.co', 'innity.net', 'medialation.net', 'p7vortex.com', 'rhown.com', 'teambetaffiliates.com', 'warezlayer.to',
				'adip.ly', 'adwhirl.com', 'blogclans.com', 'cruiseworldinc.com', 'fluxads.com', 'innovid.com', 'media-networks.ru', 'paads.dk', 'rhythmxchange.com', 'teasernet.com', 'warfacco.com',
				'adiqglobal.com', 'adwired.mobi', 'bloggerex.com', 'ctasnet.com', 'flyertown.ca', 'insightexpress.com', 'mediaonenetwork.net', 'padsdelivery.com', 'ricead.com', 'techclicks.net', 'watchfree.flv.in',
				'adiquity.com', 'adwires.com', 'blogherads.com', 'ctm-media.com', 'flymyads.com', 'insightexpressai.com', 'mediaonpro.com', 'padstm.com', 'richmedia247.com', 'technicssurveys.info', 'wateristian.com',
				'adireland.com', 'adwordsservicapi.com', 'blogohertz.com', 'ctrhub.com', 'fmdwbsfxf0.com', 'insitepromotion.com', 'mediapeo.com', 'p-advg.com', 'richwebmedia.com', 'technoratimedia.com', 'waymp.com',
				'adisfy.com', 'adworkmedia.com', 'blogscash.info', 'cubics.com', 'fmpub.net', 'insitesystems.com', 'mediaseeding.com', 'pagefair.net', 'rikhov.ru', 'telemetryverification.net', 'wbptqzmv.com',
				'adisn.com', 'adworldmedia.com', 'bluazard.net', 'cuelinks.com', 'fmsads.com', 'inskinad.com', 'media-servers.net', 'pagesinxt.com', 'ringtonematcher.com', 'teosredic.com', 'wbsadsdel.com',
				'adition.com', 'adworldmedia.net', 'blueadvertise.com', 'curancience.com', 'focalex.com', 'inskinmedia.com', 'mediatarget.com', 'paid4ad.de', 'ringtonepartner.com', 'teracent.net', 'wbsadsdel2.com',
				'aditor.com', 'adxcore.com', 'bluestreak.com', 'currentlyobsessed.me', 'focre.info', 'insta-cash.net', 'mediative.ca', 'paidonresults.net', 'ripplead.com', 'teracreative.com', 'wcmcs.net',
				'adjal.com', 'adxion.com', 'blumi.to', 'curtisfrierson.com', 'foodieblogroll.com', 'instantbannercreator.com', 'mediatraffic.com', 'paidsearchexperts.com', 'riverbanksand.com', 'terraclicks.com', 'wcpanalytics.com',
				'adjector.com', 'adxpose.com', 'bmanpn.com', 'cybmas.com', 'foonad.com', 'instantdollarz.com', 'mediatraks.com', 'pakbanners.com', 'rixaka.com', 'testfilter.com', 'weareheard.org',
				'adjug.com', 'adxpower.com', 'bnetworx.com', 'cygnus.com', 'footar.com', 'instantpaydaynetwork.com', 'medleyads.com', 'panachetech.com', 'rlex.org', 'testnet.nl', 'webads.co.nz',
				'adjuggler.com', 'adyoulike.com', 'bnhtml.com', 'd.adroll.com', 'footerslideupad.com', 'instinctiveads.com', 'medrx.sensis.com.au', 'pantherads.com', 'rmxads.com', 'text-link-ads.com', 'webads.nl',
				'adjuggler.net', 'adyoz.com', 'bnmla.com', 'd.m3.net', 'footnote.com', 'instivate.com', 'medyanet.net', 'paperg.com', 'rnmd.net', 'textonlyads.com', 'web-adservice.com',
				'adjungle.com', 'adz.co.zw', 'bnr.sys.lv', 'd03x2011.com', 'forced-lose.de', 'integral-marketing.com', 'medyanetads.com', 'paradocs.ru', 'robocat.me', 'textsrv.com', 'webadvertise123.com',
				'adk2.co', 'adzerk.net', 'bogads.com', 'd1110e4.se', 'forex-affiliate.com', 'intellibanners.com', 'meendocash.com', 'partner.googleadservices.com', 'rocketier.net', 'tfag.de', 'webgains.com',
				'adk2.com', 'adzhub.com', 'bongacams.com', 'd2ship.com', 'forex-affiliate.net', 'intellitxt.com', 'meetgoodgirls.com', 'partner.video.syndication.msn.com', 'rogueaffiliatesystem.com', 'tgtmedia.com', 'webmedia.co.il',
				'adk2.net', 'adzmob.com', 'bonusfapturbo.com', 'd3lens.com', 'forexyard.com', 'intenthq.com', 'meetic-partners.com', 'partner-ads.com', 'roicharger.com', 'th4wwe.net', 'weborama.fr',
				'adk2x.com', 'adzonk.com', 'bonzuna.com', 'da-ads.com', 'forifiha.com', 'intentmedia.net', 'meetsexygirls.org', 'partnerearning.com', 'roirocket.com', 'theadgateway.com', 'websearchers.net',
				'adkengage.com', 'adzouk.com', 'boo-box.com', 'dadegid.ru', 'forpyke.com', 'interactivespot.net', 'megacpm.com', 'partnermax.de', 'romance-net.com', 'theads.me', 'webseeds.com',
				'adkick.net', 'adzs.nl', 'booklandonline.info', 'danitabedtick.net', 'forrestersurveys.com', 'interclick.com', 'megapopads.com', 'partycasino.com', 'ronetu.ru', 'thebannerexchange.com', 'webtrackerplus.com',
				'adklip.com', 'afcyhf.com', 'boostclic.com', 'dapper.net', 'foulsomty.com', 'interestably.com', 'megbase.com', 'partypartners.com', 'rotaban.ru', 'thebflix.info', 'webtraffic.ttinet.com',
				'adknowledge.com', 'afdads.com', 'bormoni.ru', 'darwarvid.com', 'fowar.net', 'interesting.cc', 'meinlist.com', 'partypills.org', 'rotatingad.com', 'the-consumer-reporter.org', 'webusersurvey.com',
				'adkonekt.com', 'aff.biz', 'bororas.com', 'das5ku9q.com', 'f-questionnaire.com', 'intermarkets.net', 'mellowads.com', 'partypoker.com', 'rotorads.com', 'theequalground.info', 'wegetpaid.net',
				'adlayer.net', 'affbot1.com', 'boydadvertising.co.uk', 'dashboardad.net', 'frameptp.com', 'internetadbrokers.com', 'menepe.com', 'pas-rahav.com', 'roulettebotplus.com', 'thelistassassin.com', 'wegotmedia.com',
				'adlegend.com', 'affbot3.com', 'boylesportsreklame.com', 'data.adroll.com', 'freebannerswap.co.uk', 'interpolls.com', 'mentad.com', 'passionfruitads.com', 'rovion.com', 'theloungenet.com', 'weliketofuckstrangers.com',
				'adlink.net', 'affbot7.com', 'bptracking.com', 'dating-banners.com', 'freebiesurveys.com', 'interworksmedia.co.kr', 'mentalks.ru', 'pautaspr.com', 'roxyaffiliates.com', 'themidnightmatulas.com', 'wensdteuy.com',
				'adlinx.info', 'affbot8.com', 'br.rk.com', 'datinggold.com', 'freecouponbiz.com', 'intextdirect.com', 'merchenta.com', 'pay-click.ru', 'rtbidder.net', 'thepiratereactor.net', 'werbe-sponsor.de',
				'adlisher.com', 'affbuzzads.com', 'brainient.com', 'datumreact.com', 'freedownloadsoft.net', 'intextscript.com', 'mercuras.com', 'paydotcom.com', 'rtbmedia.org', 'thepornsurvey.com', 'wfnetwork.com',
				'adloaded.com', 'affec.tv', 'branchr.com', 'dbbsrv.com', 'freepaidsurveyz.com', 'intextual.net', 'messagespaceads.com', 'payperpost.com', 'rtbpop.com', 'therewardsurvey.com', 'wgreatdream.com',
				'adlooxtracking.com', 'affiliate.com', 'brand.net', 'dbclix.com', 'freerotator.com', 'intgr.net', 'metaffiliation.com', 'pc-ads.com', 'rtbpops.com', 'thewebgemnetwork.com', 'wh5kb0u4.com',
				'adlure.biz', 'affiliate.cx', 'brandads.net', 'dealcurrent.com', 'freeskreen.com', 'intopicmedia.com', 'metavertising.com', 'p-comme-performance.com', 'rterdf.me', 'thewheelof.com', 'where.com',
				'adlure.net', 'affiliate-b.com', 'brandaffinity.net', 'decisionmark.com', 'freesoftwarelive.com', 'inttrax.com', 'metavertizer.com', 'pdfcomplete.com', 'rubiconproject.com', 'thiscdn.com', 'whoads.net',
				'adlux.com', 'affiliatebannerfarm.com', 'brandclik.com', 'decisionnews.com', 'fresh8.co', 'intuneads.com', 'metodoroleta24h.com', 'p-digital-server.com', 'rubikon6.if.ua', 'thoseads.com', 'whtsrv9.com',
				'ad-m.asia', 'affiliateedge.com', 'brand-display.com', 'decknetwork.net', 'friendlyduck.com', 'inuvo.com', 'metrics.io', 'pe2k2dty.com', 'rugistoto.net', 'thoughtleadr.com', 'why-outsource.net',
				'adm.fwmrm.net/p/mtvn_live/', 'affiliateer.com', 'brandreachsys.com', 'dedicatedmedia.com', 'frtya.com', 'inuxu.co.in', 'meviodisplayads.com', 'peakclick.com', 'rummyaffiliates.com', 'thoughtsondance.info', 'widget.yavli.com',
				'admagnet.net', 'affiliatefuel.com', 'braside.ru', 'dedicatednetworks.com', 'fruitkings.com', 'investingchannel.com', 'meya41w7.com', 'peelawaymaker.com', 'runadtag.com', 'thrilamd.net', 'widgetadvertising.biz',
				'admailtiser.com', 'affiliatefuture.com', 'bravenetmedianetwork.com', 'deepmetrix.com', 'frxle.com', 'inviziads.com', 'mezimedia.com', 'peemee.com', 'rwpads.com', 'tidaltv.com', 'widgetbanner.mobi',
				'admamba.com', 'affiliate-gate.com', 'breadpro.com', 'defaultimg.com', 'frxrydv.com', 'ip-adress.com', 'mgcash.com', 'peer39.net', 'ryminos.com', 'tightexact.net', 'widgetbucks.com',
				'adman.gr', 'affiliategateways.co', 'brealtime.com', 'deguiste.com', 'ftjcfx.com', 'ipredictive.com', 'mgcashgate.com', 'penuma.com', 's.adroll.com', 'tinbuadserv.com', 'widgetlead.net',
				'admanage.com', 'affiliategroove.com', 'bridgetrack.com', 'dehtale.ru', 'ftv-publicite.fr', 'ipromote.com', 'mgplatform.com', 'pepperjamnetwork.com', 's2d6.com', 'tisadama.com', 'widgets.fccinteractive.com',
				'admarketplace.net', 'affiliatelounge.com', 'brighteroption.com', 'delivery45.com', 'fuandarst.com', 'isohits.com', 'mibebu.com', 'percularity.com', 'sa.entireweb.com', 'tiser.com', 'widgetsurvey.biz',
				'ad-maven.com', 'affiliatemembership.com', 'brightshare.com', 'delivery47.com', 'fulltraffic.net', 'isparkmedia.com', 'microad.jp', 'perfb.com', 'safeadnetworkdata.net', 'tissage-extension.com', 'widgetvalue.net',
				'admaxim.com', 'affiliate-robot.com', 'broadstreetads.com', 'delivery49.com', 'funklicks.com', 'itrengia.com', 'microadinc.com', 'perfcreatives.com', 'safecllc.com', 'tjoomo.com', 'widgetwidget.mobi',
				'admaya.in', 'affiliatesensor.com', 'brucelead.com', 'delivery51.com', 'fusionads.net', 'iu16wmye.com', 'microsoftaffiliates.net', 'perfoormapp.info', 'safelistextreme.com', 'tkqlhce.com', 'wigetmedia.com'}

	local _,_,reqURL = string.find(hc.request_header, '[gG]ET *([^;\r\n]+) HTTP/')
	for i, white in ipairs(whitelist) do
		if not re.match(reqURL, white) then
			for i, black in ipairs(blacklist) do
				if re.match(reqURL, black) then
					local function set_var(x, y)
						_G[x] = y
					end
					set_var('for_saving', 'no')
					set_var('clear', 'yes')
					local data = MY_EXTENSION_DATA[hc.monitor_index]
					table.insert(data.monitor_string_array, {priority=1, text='Blocked by Ad-Block ('..black..')'})
					set_color({153, 0, 0}, 1)
					hc.answer_header='HTTP/1.1 200 OK\r\n'..
					'Server: System\r\n'..
					'Content-Type: text/html\r\n'..
					'Pragma: no-cache\r\n'..
					'Cache-control: no-cache, must-revalidate, no-store\r\n'..
					'Connection: close\r\n\r\n'
					hc.answer_body =[[
<html>
	<head>
		<link rel="shortcut icon" href="]]..server_favicon..[[">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="keywords" content="Error">
		<meta name="description" content="Error">
		<meta name="copyright" content="">
		<meta name="robots" content="noindex">
		<meta name="cache-control" content="no-cache">
		<meta name="pragma" content="no-cache">
		<title>]]..server_name..[[ - Blocked by Ad-Block (]]..black..[[)</title>
		<style type="text/css">
			@font-face {
				font-family: 'Bahamas';
				src: url(data:application/font-woff;charset=utf-8;base64,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) format('woff');
				font-weight: normal;
				font-style: normal;
			}
			body {
				background: rgba(0, 0, 0, 0);
				overflow: auto;
				margin: 0px 0px 0px 0px;
				padding: 0px 0px 0px 0px;
				font-family: Bahamas, "Trebuchet MS", Verdana, Myriad Pro, Arial, Helvetica, sans-serif;
				font-size: 14px;
				font-color: #000000;
			}
			hr {
				width: 80%;
				height: 1px;
				border: none;
				color:#000000;
				background-color:#000000;
			}
			a {
				color: #2d2d86;
				text-decoration: none;

				transition: all 0.2s ease;
				-webkit-transition: all 0.5s ease-in-out;
				-moz-transition: all 0.5s ease-in-out;
				-ms-transition: all 0.5s ease-in-out;
				-o-transition: all 0.5s ease-in-out;
			}
			a:hover {
				color: #ffffff;
				-webkit-transition: none;
				text-shadow: 0px 0px 5px rgba(0, 0, 0, 1), 0px 0px 5px rgba(0, 0, 0, 1), 0px 3px 15px rgba(0, 0, 0, 0.60);
			}
			a:active {
				color: #2d2d86;
			}
			a:visited {
				color: #2d2d86;
			}

			.fixed {
				position:fixed;
			}
			.layer-one {
				z-index: 1;
				width: 100%;
				height: 100%;
			}
			.layer-two {
				z-index: 2;
				width: 100%;
				height: 100%;
			}
			.layer-six {
				z-index: 6;
				width: 100%;
				height: 100%;
			}
			.layer-ten {
				z-index: 10;
			}
			.layer-eleven {
				z-index: 11;
			}
			.layer-fifteen {
				z-index: 15;
				width: 100%;
				height: 100%;
			}
			.overlay-gradient {
				position: absolute;
				background: radial-gradient(at 50% 45%, rgba(255,255,255,.75) 5%, rgba(0,0,0,.8) 95%);
				background-color: rgb(255, 0, 0);
  				width: 100%;
				height: 100%;
			}
			.overlay-cross {
				position: absolute;
				top: 40%;
				left: 50%;
				transform: translate(-50%, -50%);
				color: transparent;
				font-weight: bold;
				font-size: 900px;

				text-shadow: 0 0 14px #000000;
				-webkit-filter: blur(6px);
				-moz-filter: blur(6px);
				-ms-filter: blur(6px);
				-o-filter: blur(6px);
				filter: blur(6px);
				opacity: 0.15;
			}
			.overlay-internet {
				position: absolute;
				color: #ffffff;
				text-align: center;
				font-weight: bold;
				font-size: 30px;
				bottom: 70px;
				right: 20px;
				line-height: 35px;
				
				-webkit-filter: blur(2px);
				-moz-filter: blur(2px);
				-ms-filter: blur(2px);
				-o-filter: blur(2px);
				filter: blur(2px);
				opacity: 0.45;
			}
			.content {
				position: absolute;
				display: table;
				height: 90%;
				width: 100%;
				z-index: 5;
				text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.75), 0px 2px 15px rgba(0, 0, 0, 0.40);
			}
			.content-item {
				display: table-cell;
				vertical-align: middle;
				padding-left: 40px;
				padding-right: 40px;
				padding-top: 80px;
				padding-bottom: 50px;
				letter-spacing: 1px;
			}
			.overlay-top {
				top: 0px;
				left: -450px;
				width: 3500px;
				height: 80px;
				background: radial-gradient(115% 100px ellipse at 96% 80px, rgba(0, 0, 0, 0) 75.5%, rgba(255, 255, 255, 1) 76%, rgba(0, 0, 0, 0.4) 77.5%, rgba(0, 0, 0, 1) 120%);
			}
			.overlay-top-item-symbol {
				top: -2px;
				left: 40px;
				font-family: Bahamas, "Trebuchet MS", Verdana, Myriad Pro, Arial, Helvetica, sans-serif;
				font-size: 46px;
				font-weight: bold;
				color: #ffa500;
				letter-spacing: 15px;
				text-shadow: 0px 0px 5px rgba(0, 0, 0, 1);
			}
			.overlay-top-item-text {
				top: 15px;
				left: 75px;
				font-family: Bahamas, "Trebuchet MS", Verdana, Myriad Pro, Arial, Helvetica, sans-serif;
				font-size: 19px;
				font-weight: bold;
				color: #ffffff; 
				letter-spacing: 15px;
				text-shadow: 0px 0px 1px rgba(255, 255, 255, 1), 0px 0px 5px rgba(0, 0, 0, 1), 0px 0px 15px rgba(0, 0, 0, 0.50);
			}
			.overlay-bottom {
				bottom: 0px;
				right: -450px;
				width: 3500px;
				height: 80px;
				background: radial-gradient(85% 100px ellipse at 35% 0px, rgba(0, 0, 0, 0) 75.5%, rgba(255, 255, 255, 1) 76%, rgba(0, 0, 0, 0.4) 77.5%, rgba(0, 0, 0, 1) 100%);
			}
			.overlay-bottom-item {
				bottom: 9px;
				right: 40px;
				font-family: Bahamas, "Trebuchet MS", Verdana, Myriad Pro, Arial, Helvetica, sans-serif;
				font-size: 12px;
				font-weight: bold;
				color: #ffffff; 
				letter-spacing: 7px;
				text-shadow: 0px 0px 3px rgba(0, 0, 0, 1), 0px 0px 10px rgba(0, 0, 0, 0.50);
			}
		</style>
	</head>
	<body>
		<div class="fixed layer-ten overlay-top"></div>
		<div class="fixed layer-ten overlay-bottom"></div>
		<div class="fixed layer-eleven overlay-top-item-symbol"><strong>&raquo;</strong></div>
		<div class="fixed layer-eleven overlay-top-item-text"><strong>ERROR</strong></div>
		<div class="fixed layer-eleven overlay-bottom-item">HandyCache</div>

		<div class="fixed layer-one">
			<div class="overlay-gradient"></div>
		</div>

		<div class="fixed layer-two">
			<div class="overlay-cross"><strong>×</strong></div>
			<div class="overlay-internet">s<br>e<br>r<br>v<br>e<br>r<br><br>i<br>n<br>f<br>o</div>
		</div>

		<div class="content">
			<div class="content-item font-face">
				<div class="margin-top"></div>


				<div align="center">
					<span style="font-size:36px;"><strong>Site is blocked!</strong></span><br><br><br>
					<span style="font-size:22px;"><hr><br>Blocked URL:</span><br>
					<span style="font-family:Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New; font-size:14px; color: #8b0000;"><strong>]]..hc.url..[[</strong></span>
					<br><br><br><br>
					<span style="font-size:22px;">Blocked expression:</span><br>
					<span style="font-family:Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New; font-size:24px; color: #8b0000;"><strong>]]..black..[[</strong></span>
					<br><br><br><hr><br><br>
					<span style="font-size:16px;"><strong>contact: <a href="mailto:]]..admin_mail..[[">]]..admin_name..[[</a></strong></span>
				</div>


				<div class="margin-bottom"></div>
			</div>
		</div>
	</body>
</html>
]] -- ]]..reqURL..[[ and ]]..black..[[ is variable for information
					hc.action = 'stop'
				end
			end
		end
	end
end