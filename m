Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7CF1704C6
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 17:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgBZQq6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Feb 2020 11:46:58 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45398 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgBZQqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 11:46:54 -0500
Received: by mail-oi1-f195.google.com with SMTP id v19so103943oic.12
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 08:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfFrdPdZ9FoWsLEItIHfFzP9ymFVjyGzad5UqI1rEBE=;
        b=LLkXP/3YzNaP8jdt0z93QGulQGLXQX0Trzd+WFJYkXo7XFWuAJ6wZlyGff03QwBHLf
         4Plc4q/Qd0QJCdIf1e9GoeaXEwKZlw9ETZjCukpkMrdt9ZR/Sr44zYE50Gip8IOl5r/m
         JYB1LSlrJ5+0Ka91jrB29f9SbGT869H3/DqAXOp34IH/Yoc3vP+//hshViJUUDDqS/LJ
         QNCuX04I8VWPdsbprpmw1cyzBOjBzRkd1MECp+iNhZ3/lxaXqckVfJPRynNgiP/ijnQg
         eiPa77p4MyvubAypJgQy1RxojQg1rNwgRioANNu+yBxI55olFfbCnrSGU/LHQ65MMRHT
         vO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfFrdPdZ9FoWsLEItIHfFzP9ymFVjyGzad5UqI1rEBE=;
        b=TihrpLwjlIqfBqd9D1TxMjdLGGmi32UqZNXKp2JIzafbjoH01Rmsih6cLjqti04dPG
         bF/Q66QdWIPOX7MjatxsVRNrEJPFiiCqPWVAzcTikMSI/66Mou1CxKWwqwq4qAwZv6Xc
         H1JNgG8FB6hDIi0SKfHL50OpTFo+jgC2q/6BeyNVtWAgBNBhw35SCBaT0NLSldxCNUBS
         tJVslfPM5HnLOoIYSGYpLWffD2hvDzHVu6MhRlPc/FQPgDmxvZ5HRfmlR7HP9NvHotOq
         YnpKqwN53+ZMsmpomT9VJe67Xj/FVxjLd66fzcY7WEQzN3BZIXdHH4TLDD8B57yK3710
         /3rw==
X-Gm-Message-State: APjAAAV3FqWWsG4yiLZcUA5qlMOqZFG2EfN7+y19+rh3Y5jGxIvtEj2R
        uHitXPDObZpCQJyOSSEWcDZjc/OnVO5OhcwhOKAVSQ==
X-Google-Smtp-Source: APXvYqxqs6rTVc9eevxeNThlba+uZVaIe7nbgX9rqBRXGHLdPOffytT7975QEGYC3CSiSUYJqJj/25GH1DMT/gSZElU=
X-Received: by 2002:aca:4c9:: with SMTP id 192mr4075244oie.105.1582735614183;
 Wed, 26 Feb 2020 08:46:54 -0800 (PST)
MIME-Version: 1.0
References: <20200221004134.30599-1-ira.weiny@intel.com> <20200221004134.30599-8-ira.weiny@intel.com>
 <20200221174449.GB11378@lst.de> <20200221224419.GW10776@dread.disaster.area>
 <20200224175603.GE7771@lst.de> <20200225000937.GA10776@dread.disaster.area>
 <20200225173633.GA30843@lst.de> <x49fteyh313.fsf@segfault.boston.devel.redhat.com>
 <a126276c-d252-6050-b6ee-4d6448d45fac@redhat.com>
In-Reply-To: <a126276c-d252-6050-b6ee-4d6448d45fac@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 26 Feb 2020 08:46:42 -0800
Message-ID: <CAPcyv4iuWpHi-0SK_HS0zmfH87=G64U47VhthhpTjDCw_BMG8A@mail.gmail.com>
Subject: Re: [PATCH V4 07/13] fs: Add locking for a dynamic address space
 operations state
To:     Jonathan Halliday <jonathan.halliday@redhat.com>
Cc:     Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 1:29 AM Jonathan Halliday
<jonathan.halliday@redhat.com> wrote:
>
>
> Hi All
>
> I'm a middleware developer, focused on how Java (JVM) workloads can
> benefit from app-direct mode pmem. Initially the target is apps that
> need a fast binary log for fault tolerance: the classic database WAL use
> case; transaction coordination systems; enterprise message bus
> persistence and suchlike. Critically, there are cases where we use log
> based storage, i.e. it's not the strict 'read rarely, only on recovery'
> model that a classic db may have, but more of a 'append only, read many
> times' event stream model.
>
> Think of the log oriented data storage as having logical segments (let's
> implement them as files), of which the most recent is being appended to
> (read_write) and the remaining N-1 older segments are full and sealed,
> so effectively immutable (read_only) until discarded. The tail segment
> needs to be in DAX mode for optimal write performance, as the size of
> the append may be sub-block and we don't want the overhead of the kernel
> call anyhow. So that's clearly a good fit for putting on a DAX fs mount
> and using mmap with MAP_SYNC.
>
> However, we want fast read access into the segments, to retrieve stored
> records. The small access index can be built in volatile RAM (assuming
> we're willing to take the startup overhead of a full file scan at
> recovery time) but the data itself is big and we don't want to move it
> all off pmem. Which means the requirements are now different: we want
> the O/S cache to pull hot data into fast volatile RAM for us, which DAX
> explicitly won't do. Effectively a poor man's 'memory mode' pmem, rather
> than app-direct mode, except here we're using the O/S rather than the
> hardware memory controller to do the cache management for us.
>
> Currently this requires closing the full (read_write) file, then copying
> it to a non-DAX device and reopening it (read_only) there. Clearly
> that's expensive and rather tedious. Instead, I'd like to close the
> MAP_SYNC mmap, then, leaving the file where it is, reopen it in a mode
> that will instead go via the O/S cache in the traditional manner. Bonus
> points if I can do it over non-overlapping ranges in a file without
> closing the DAX mode mmap, since then the segments are entirely logical
> instead of needing separate physical files.

Hi John,

IIRC we chatted about this at PIRL, right?

At the time it sounded more like mixed mode dax, i.e. dax writes, but
cached reads. To me that's an optimization to optionally use dax for
direct-I/O writes, with its existing set of page-cache coherence
warts, and not a capability to dynamically switch the dax-mode.
mmap+MAP_SYNC seems the wrong interface for this. This writeup
mentions bypassing kernel call overhead, but I don't see how a
dax-write syscall is cheaper than an mmap syscall plus fault. If
direct-I/O to a dax capable file bypasses the block layer, isn't that
about the maximum of kernel overhead that can be cut out of this use
case? Otherwise MAP_SYNC is a facility to achieve efficient sub-block
update-in-place writes not append writes.
