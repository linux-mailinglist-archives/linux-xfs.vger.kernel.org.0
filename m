Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B422C11D4C8
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2019 19:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfLLSBs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Dec 2019 13:01:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730034AbfLLSBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 13:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576173708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dAtIMPnXPAmRN5c8ogP3gmaxPCv12KR71V4MrWXrjjc=;
        b=RmX8wXFHHwiG9VvReMNQlSO6b+cIUrYavDZZtEY/IMn/POEtXD3rSoRuJmBCHX5pPqcqNQ
        s3yxK/yfcxQwwkw/4cpZC4HQ3MZ4L1EVv+MVdNMBQ9nMMBn7QIt7FPddW68UtJ6BaDUHBN
        polne0solAEszqDznEZsTuf8qMf02l0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-lH63_70AN9KRDe8S9pwZWQ-1; Thu, 12 Dec 2019 13:01:44 -0500
X-MC-Unique: lH63_70AN9KRDe8S9pwZWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E5A4800D4E;
        Thu, 12 Dec 2019 18:01:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 365A8601B6;
        Thu, 12 Dec 2019 18:01:43 +0000 (UTC)
Date:   Thu, 12 Dec 2019 13:01:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 205833] New: fsfreeze blocks close(fd) on xfs sometimes
Message-ID: <20191212180142.GA37977@bfoster>
References: <bug-205833-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-205833-201763@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 02:03:52PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=205833
> 
>             Bug ID: 205833
>            Summary: fsfreeze blocks close(fd) on xfs sometimes
>            Product: File System
>            Version: 2.5
>     Kernel Version: 4.15.0-55-generic #60-Ubuntu
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: kernel.org@estada.ch
>         Regression: No
> 
> Dear all
> 
> I noticed the bug while setting up a backup with fsfreeze and restic.
> 
> How I reproduce it:
> 
>     1. Write multiple MB to a file (eg. 100MB) while after one or two MB freeze
> the filesystem from the sidecar pod
>     2. From the sidecar pod, issue multiple `strace tail /generated/data/0.txt`
>     3. After a couple of tries strace shows that the `read(...)` works but
> `close(...)` hangs
>     4. From now on all `read(...)` operations are blocked until the freeze is
> lifted
> 

I'm not familiar with your user environment, but it sounds like the use
case is essentially to read a file concurrently being written to and
freeze the fs. From there, you're expecting the readers to exit but
instead observe them blocked on close().

The ceaveat to note here is that close() is not necessarily a read-only
operation from the perspective of XFS internals. A close() (or
->release() from the fs perspective) can do things like truncate
post-eof block allocation, which requires a transaction and thus blocks
on a frozen fs. To confirm, could you post a stack trace of one of your
blocked reader tasks (i.e. 'cat /proc/<pid>/stack')?

I'm not necessarily sure blocking here is a bug if that is the
situation. We most likely wouldn't want to skip post-eof truncation on a
file simply because the fs was frozen. That said, I thought Dave had
proposed patches at one point to mitigate free space fragmentation side
effects of post-eof truncation, and one such patch was to skip the
truncation on read-only fds. I'll have to dig around or perhaps Dave can
chime in, but I'm curious if that would also help with this use case..

Brian

> System: Ubuntu 18.04.3 LTS
> CPU: Intel(R) Xeon(R) CPU X5650  @ 2.67GHz
> Storage: /dev/mapper/mpathXX on /var/lib/kubelet/plugins/hpe.com/... type xfs
> (rw,noatime,attr2,inode64,noquota)
> 
> I used this tool to generate the file. The number of concurrent files does not
> appear to matter that much. I was able to trigger the bug, tested with 2, 4 and
> 32 parallel files:
> https://gitlab.com/dns2utf8/multi_file_writer
> 
> Cheers,
> Stefan
> 
> PS: I opened a bug at the tool vendor too:
> https://github.com/vmware-tanzu/velero/issues/2113
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

