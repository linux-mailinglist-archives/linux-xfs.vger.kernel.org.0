Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009BC590DEE
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Aug 2022 11:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbiHLJNt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Aug 2022 05:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiHLJNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Aug 2022 05:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C02ACA98E4
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 02:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660295626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqh86e5fPd2SRzTqhs3slx8d2YjRVHEu4SBkvhufz8A=;
        b=Jig0I3mDWfk+ozc/RWjm4L/C9NtkjtjXwXmLSE+LySvVz6JBV0gFyqCrqO7CY4KI0MfzKF
        B7mLHQY9PTr/zJTBi+Li/K5mJUBV8x021r1BCi6tAN7e41NLbGdEWgGKHm/WsuLE+IQ6pL
        6sN8Tjv9MplmTC5VH85wRy6Khf8Z4VE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-4dc20pL-M92PlKuhKBaMJQ-1; Fri, 12 Aug 2022 05:13:45 -0400
X-MC-Unique: 4dc20pL-M92PlKuhKBaMJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB1FC811E76
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 09:13:44 +0000 (UTC)
Received: from [10.10.0.108] (unknown [10.40.192.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 123C92026D4C
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 09:13:43 +0000 (UTC)
Subject: [PATCH 2/2] Rename worker threads from xfsdump's documentation
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Aug 2022 11:13:43 +0200
Message-ID: <166029562304.24268.7994422214489083444.stgit@orion>
In-Reply-To: <166029523522.24268.4512887046014709993.stgit@orion>
References: <166029523522.24268.4512887046014709993.stgit@orion>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While we've already removed the word 'slave' from the code, the
documentation should still be updated.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/xfsdump.html |   38 +++++++++++++++++++-------------------
 po/de.po         |    4 ++--
 po/pl.po         |    4 ++--
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index e37e362..2faa65e 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -286,7 +286,7 @@ of a dump/restore session to multiple drives.
 	   |      |      |
 4.	   O      O      O	ring buffers common/ring.[ch]
            |      |      |
-5.	 slave  slave   slave	ring_create(... ring_slave_entry ...)
+5.	worker  worker  worker	ring_create(... ring_worker_entry ...)
 	thread  thread  thread
 	   |      |      |
 6.	 drive  drive   drive	physical drives
@@ -306,7 +306,7 @@ The process hierachy is shown above. main() first initialises
 the drive managers with calls to the drive_init functions. In
 addition to choosing and assigning drive strategies and ops for each
 drive object, the drive managers intialise a ring buffer and (for
-devices other than simple UNIX files) sproc off a slave thread that
+devices other than simple UNIX files) sproc off a worker thread that
 that handles IO to the tape device. This initialisation happens in the
 drive_manager code and is not directly visible from main().
 <p>
@@ -316,31 +316,31 @@ sprocs. Each child begins execution in childmain(), runs either
 content_stream_dump or content_stream_restore and exits with the
 return code from these functions.
 <p>
-Both the stream manager processes and the drive manager slaves
+Both the stream manager processes and the drive manager workers
 set their signal disposition to ignore HUP, INT, QUIT, PIPE,
 ALRM, CLD (and for the stream manager TERM as well).
 <p>
-The drive manager slave processes are much simpler, and are
+The drive manager worker processes are much simpler, and are
 initialised with a call to ring_create, and begin execution in
-ring_slave_func. The ring structure must also be initialised with
+ring_worker_func. The ring structure must also be initialised with
 two ops that are called by the spawned thread: a ring read op, and a write op.
 The stream manager communicates with the tape manager across this ring
 structure using Ring_put's and Ring_get's.
 <p>
-The slave thread sits in a loop processing messages that come across
+The worker thread sits in a loop processing messages that come across
 the ring buffer. It ignores signals and does not terminate until it
 receives a RING_OP_DIE message. It then exits 0.
 <p>
 The main process sleeps waiting for any of its children to die
 (ie. waiting for a SIGCLD). All children that it cares about (stream
-managers and ring buffer slaves) are registered through the child
+managers and ring buffer workers) are registered through the child
 manager abstraction. When a child dies wait status and other info is
 stored with its entry in the child manager. main() ignores the deaths
 of children (and grandchildren) that are not registered through the child
 manager. The return status of these subprocesses is checked
 and in the case of an error is used to determine the overall exit code.
 <p>
-We do not expect slave threads to ever die unexpectedly: they ignore
+We do not expect worker threads to ever die unexpectedly: they ignore
 most signals and only exit when they receive a RING_OP_DIE at which
 point they drop out of the message processing loop and always signal success.
 <p>
@@ -1680,35 +1680,35 @@ If xfsdump/xfsrestore is running single-threaded (-Z option)
 or is running on Linux (which is not multi-threaded) then
 records are read/written straight to the tape. If it is running
 multi-threaded then a circular buffer is used as an intermediary
-between the client and slave threads.
+between the client and worker threads.
 <p>
 Initially <i>drive_init1()</i> calls <i>ds_instantiate()</i> which
 if dump/restore is running multi-threaded,
 creates the ring buffer with <i>ring_create</i> which initialises
-the state to RING_STAT_INIT and sets up the slave thread with
-ring_slave_entry.
+the state to RING_STAT_INIT and sets up the worker thread with
+ring_worker_entry.
 <pre>
 ds_instantiate()
   ring_create(...,ring_read, ring_write,...)
     - allocate and init buffers
     - set rm_stat = RING_STAT_INIT
-    start up slave thread with ring_slave_entry
+    start up worker thread with ring_worker_entry
 </pre>
-The slave spends its time in a loop getting items from the
+The worker spends its time in a loop getting items from the
 active queue, doing the read or write operation and placing the result
 back on the ready queue.
 <pre>
-slave
+worker
 ======
-ring_slave_entry()
+ring_worker_entry()
   loop
-    ring_slave_get() - get from active queue
+    ring_worker_get() - get from active queue
     case rm_op
       RING_OP_READ -> ringp->r_readfunc
       RING_OP_WRITE -> ringp->r_writefunc
       ..
     endcase
-    ring_slave_put() - puts on ready queue
+    ring_worker_put() - puts on ready queue
   endloop
 </pre>
 
@@ -1778,7 +1778,7 @@ prepare_drive()
 <p>
 For each <i>do_read</i> call in the multi-threaded case,
 we have two sides to the story: the client which is coming
-from code in <i>content.c</i> and the slave which is a simple
+from code in <i>content.c</i> and the worker which is a simple
 thread just satisfying I/O requests.
 From the point of view of the ring buffer, these are the steps
 which happen for reading:
@@ -1786,7 +1786,7 @@ which happen for reading:
 <li>client removes msg from ready queue
 <li>client wants to read, so sets op field to READ (RING_OP_READ)
    and puts on active queue
-<li>slave removes msg from active queue,
+<li>worker removes msg from active queue,
    invokes client read function,
    sets status field: OK/ERROR,
    puts msg on ready queue
diff --git a/po/de.po b/po/de.po
index 62face8..baaa8be 100644
--- a/po/de.po
+++ b/po/de.po
@@ -446,8 +446,8 @@ msgstr ""
 "zurück, Fehlernummer %d (%s)\n"
 
 #: .././common/drive_minrmt.c:3823
-msgid "slave"
-msgstr "Slave"
+msgid "worker"
+msgstr "worker"
 
 #: .././common/drive_minrmt.c:3891 .././common/drive_minrmt.c:3899
 msgid "KB"
diff --git a/po/pl.po b/po/pl.po
index 3cba8d6..f999525 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -1327,8 +1327,8 @@ msgid "lock ordinal violation: tid %lu ord %d map %x\n"
 msgstr "naruszenie porządku blokad: tid %lu ord %d map %x\n"
 
 #: .././common/ring.c:127
-msgid "slave"
-msgstr "podrzędnego"
+msgid "worker"
+msgstr ""
 
 #: .././common/util.c:188 .././dump/content.c:2867
 #, c-format


