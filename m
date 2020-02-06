Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608D4153DE2
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2020 05:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBFEfD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Feb 2020 23:35:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727737AbgBFEfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 23:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580963702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXuKPxjpt6+nraBWBkpCm4C5OhCyIDIBXSJPQtpCHXc=;
        b=hHU6qbGgIU6qb3E+KStrP8R6Twtr5Ic7s4410Gnf/nP2LLDxUFrNodYfRnM6cidHZjhZJw
        cl94j8zy+Y5YCXL47OQReFn1+5/QLzAfDHPe07FCkrtzyI3MGa9hZYiiM/DOGdE65rWttc
        jRnPOfZRLt6EBCzkr9qNRvgHxVDvYSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-WiM6452MMbKqDslAchX-Kw-1; Wed, 05 Feb 2020 23:34:58 -0500
X-MC-Unique: WiM6452MMbKqDslAchX-Kw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 566DE2F2A;
        Thu,  6 Feb 2020 04:34:57 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF94D857B2;
        Thu,  6 Feb 2020 04:34:56 +0000 (UTC)
Date:   Thu, 6 Feb 2020 12:44:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs/020: fix truncation test
Message-ID: <20200206044450.GQ14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <158086090225.1989378.6869317139530865842.stgit@magnolia>
 <158086091464.1989378.4282506455041445127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086091464.1989378.4282506455041445127.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:01:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we can't create the 60T sparse image for testing repair on a large fs
> (such as when running on 32-bit), don't bother running the rest of the
> test.  This requires the actual truncate(1) command, because it returns
> nonzero if the system call fails.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/020 |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/020 b/tests/xfs/020
> index 66433b0a..4f617379 100755
> --- a/tests/xfs/020
> +++ b/tests/xfs/020
> @@ -42,7 +42,9 @@ echo "Silence is golden"
>  
>  fsfile=$TEST_DIR/fsfile.$seq
>  rm -f $fsfile
> -$XFS_IO_PROG -f -c "truncate 60t" $fsfile || _notrun "Cannot create 60T sparse file for test."
> +# The actual truncate command is required here (and not xfs_io) because it
> +# returns nonzero if the operation fails.
> +truncate -s 60t $fsfile || _notrun "Cannot create 60T sparse file for test."

Good to me.

>  rm -f $fsfile
>  
>  $MKFS_PROG -t xfs -d size=60t,file,name=$fsfile >/dev/null
> 

