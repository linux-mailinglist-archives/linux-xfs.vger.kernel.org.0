Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8155D7240B
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 03:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfGXBwt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 21:52:49 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:38457 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGXBwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 21:52:49 -0400
Received: by mail-pf1-f173.google.com with SMTP id y15so20056521pfn.5
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 18:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=zJ2ZrnENwVACXY1kQ8xq+AHslWptY93nAERKRz0kc84=;
        b=m2KeQS69YLU0iYJAmu+i81BZFw9dJNmOJSZTfxCX2FAWM4muGgddEFxj/559UvbeIi
         yPBNVOunn8HlrMI7mvRcEHHgxswdBE1e55ZdhJriserz7t1kk401EU9ta/xnxcLLATUW
         1J7elH/gBWjfEs67qBs5Z63ltmf35wdt//dKfx+Bf4jh7/cgc/7GAV+UI1qEQEILHrT+
         RbQnX04WjopE/4/VahO+H7bzlkhb00IrrLzd44a+H/DC+5lFBRsraO7CDc2leikcWzdQ
         dndyPRC0VZFyPs3sfcToEbQuj/p02D1CDIc5hurOMW46MdegQd2B2bzyPJo261xMmulI
         6NVA==
X-Gm-Message-State: APjAAAUe8BTs/h+XQJSEjR2nwgGeeoCzFX01165Ont3b7wqsn0FZ748D
        sgRwHmVc58ANeqdb13x+TA86Z9Co
X-Google-Smtp-Source: APXvYqy95SBsI95UC3NczrvIc+CR96qKzoDimsjCsIBBUeK9KYkR9MBbdoy/lQoPN3QuUc/l9oUMSA==
X-Received: by 2002:a63:1f03:: with SMTP id f3mr50915185pgf.249.1563933168194;
        Tue, 23 Jul 2019 18:52:48 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w22sm47776301pfi.175.2019.07.23.18.52.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 18:52:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id AF76F402A1; Wed, 24 Jul 2019 01:52:46 +0000 (UTC)
Date:   Wed, 24 Jul 2019 01:52:46 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: fstests: cannot allocate memory - false negatives xfs/059
Message-ID: <20190724015246.GR30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm seeing at least one test fail but in reality it doesn't
seem like a real failure, only memory pressure for a small
period of time, and the test actually passed. But it failed
since there was a difference in output.

I see this has been discussed but the emails date back years ago
and then refer to discussions using a URL which no longer exists.
As such I cannot determine what the conclusion was.

For example, the test below actually is fine, but just because it
display two extra lines of "Cannot allocate memory" its reported as a
failure.

What was the agreement to deal with this? Was there any? If no
agreement was reached, what about just excluding these lines from
the output, or modifying the utilities to not display such messages
unless a verbsose flag was passed.

I tried looking for xfsrestore to see where this would be coming from
and don't see that... so again.. still not sure what to do yet.

Thoughts?

SECTION       -- xfs_nocrc_512
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 oscheck-xfs-nocrc-512 4.19.58 #1 SMP Wed
Jul 17 06:37:34 UTC 2019
MKFS_OPTIONS  -- -f -f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, -b
size=512, /dev/loop5
MOUNT_OPTIONS -- /dev/loop5 /media/scratch

xfs/059 14s ... - output mismatch (see
/var/lib/xfstests/results/oscheck-xfs-nocrc-512/4.19.58/xfs_nocrc_512/xfs/059.out.bad)
--- tests/xfs/059.out       2019-07-17 06:53:54.439742882 +0000
+++
/var/lib/xfstests/results/oscheck-xfs-nocrc-512/4.19.58/xfs_nocrc_512/xfs/059.out.bad
2019-07-23 18:36:06.530062007 +0000
@@ -29,6 +29,8 @@
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: using file dump (drive_simple)
strategy
xfsrestore: using file dump (drive_simple)
strategy
+ Cannot allocate memory
+ Cannot allocate memory
xfsrestore: restore complete:
SECS seconds elapsed
xfsrestore: Restore Status:
SUCCESS
...
(Run 'diff -u
/var/lib/xfstests/tests/xfs/059.out
/var/lib/xfstests/results/oscheck-xfs-nocrc-512/4.19.58/xfs_nocrc_512/xfs/059.out.bad'
to see the entire
diff)
Ran: xfs/059
Failures: xfs/059
Failed 1 of 1 tests


