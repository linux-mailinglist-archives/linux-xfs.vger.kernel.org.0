Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD91C54E8
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 13:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEEL6R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 May 2020 07:58:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727090AbgEEL6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 07:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588679895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7lyvXJ5DuoenPOxI+FBP/XOYDK6e/RtCSUuPqVfZI80=;
        b=HGPkD9skbtf+F3Oe57d0uQGcgfrq2hggDRBPrCYyNwnGj0fWMebD7aU/dnDGX2ed67OtJg
        ereWtiZGw0UDGu3wlLWcSfhDPI+jnk+64k1KfMgetICy6U7AVBw+PMyxLwo7ZZYENygrUd
        Iq5lBsEnlhVLRJoKph3RtSeuzYWe+Ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-vzLK3MBxMnGA-O7voMpEWg-1; Tue, 05 May 2020 07:58:13 -0400
X-MC-Unique: vzLK3MBxMnGA-O7voMpEWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00D1D107ACCA;
        Tue,  5 May 2020 11:58:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB09260E1C;
        Tue,  5 May 2020 11:58:12 +0000 (UTC)
Date:   Tue, 5 May 2020 07:58:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 00/17] xfs: flush related error handling cleanups
Message-ID: <20200505115810.GA60048@bfoster>
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504215307.GL2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504215307.GL2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 07:53:07AM +1000, Dave Chinner wrote:
> On Mon, May 04, 2020 at 10:11:37AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > I think everything has been reviewed to this point. Only minor changes
> > noted below in this release. A git repo is available here[1].
> > 
> > The only outstanding feedback that I'm aware of is Dave's comment on
> > patch 7 of v3 [2] regarding the shutdown assert check. I'm not aware of
> > any means to get through xfs_wait_buftarg() with a dirty buffer that
> > hasn't undergone the permanant error sequence and thus shut down the fs.
> 
> # echo 0 > /sys/fs/xfs/<dev>/fail_at_unmount
> 
> And now any error with a "retry forever" config (the default) will
> be collected by xfs_buftarg_wait() without a preceeding shutdown as
> xfs_buf_iodone_callback_error() will not treat it as a permanent
> error during unmount. i.e. this doesn't trigger:
> 
>         /* At unmount we may treat errors differently */
>         if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
>                 goto permanent_error;
> 
> and so the error handling just marks it with a write error and lets
> it go for a write retry in future. These are then collected in
> xfs_buftarg_wait() as nothing is going to retry them once unmount
> gets to this point...
> 

That doesn't accurately describe the behavior of that configuration,
though. "Retry forever" means that dirty buffers are going to cycle
through submission retries and the unmount is going to hang indefinitely
(on pushing the AIL). Indeed, preventing this unmount hang is the
original purpose of the fail at unmount knob (commit here[1]).

IOW, we don't get to xfs_wait_buftarg() in that scenario until all dirty
buffers are either written back successfully or the error configuration
changes to process the failures as permanent errors and shuts down the
fs. This can be confirmed easily with the buffer I/O error injection
patch (use a value of 1 to simulate persistent errors).

Brian

[1] e6b3bb78962e6 ("xfs: add "fail at unmount" error handling configuration")

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

