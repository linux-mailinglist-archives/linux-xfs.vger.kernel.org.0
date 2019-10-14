Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FCD5DE3
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2019 10:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbfJNIw3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Oct 2019 04:52:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39166 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbfJNIw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 04:52:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so368115pgn.6
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2019 01:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbobrowski-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AIRc/FaicU56+x04UFR4BmB8mTK9vi0gG2txvtio5hg=;
        b=Y7dz4/X3uD/Bsf+PUZqJID/CRfkxmefV8Jvbo4YXJHnBBUgbnxv1z9I0pWrrDQVX+Z
         YdRDvhZDO7nm11/QfJNUAfxmMTcR8pl+u90KRhpmoSn4RBNzEftEjdV674SluUNl1eLP
         h9LqX5KWqheV/mDihvcv5BijJtMrzjw7yDsoUj/1+TpMQ67vVhMWuc+62s9r5syUSE5o
         szBw5K+7MITxEQfJ6R+pfn6fKHcLRVdxbufI7L/MMSXiAEO1XOZI3jVIAnbJJNQ4E78l
         aWTc2Ld451dpaozwW53BpOOe/uM0aw9lhPF54X8YZPpIrX73/i6Qx82cRPuY0JrQW8Zr
         Ix8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AIRc/FaicU56+x04UFR4BmB8mTK9vi0gG2txvtio5hg=;
        b=pSPITJAVy6ile1hsLMdgX8kkh7K4KfT8580c1IYdWcpl7LHz6awPenF0zVlQYOPurN
         49RvL+wjRQBtW+P5N9b7azsgorFVfWZYK4hdnY5SgZh8JdHitgh40DCnRICjFxnFhoSJ
         q+E88X+dtzDwRVvs42BXWjBx201gAiRKBrRT4sDBONUi/mB2KeyyEK/aecfreVKsPxkH
         6ZZMx5/ktQMMp68Z/0PqgykIi9WVtwXI+XvP68E9sDGvNvHrEUI/Oa8v5FJzABiTFtoT
         ZTnj9lFmv9AIkEClF2NK8hNQTUgtonnr9Jug7AdNjXkWyq83ipvrpLjsX64pLAorwlPe
         Wepg==
X-Gm-Message-State: APjAAAXQ/RdTVqlTX9lfIoayJXo+AHgzA6n+38VwOCSg5L0YVbWMophV
        10iBIeAOBoV5rR3EwRUEQ1Gx
X-Google-Smtp-Source: APXvYqzlApQtLhGenT3SpvrnsKz2M9F77t4OCF7q9JWJcXGR5i9AyzEpxV2LYUqpIX6C+Sf5nubqnQ==
X-Received: by 2002:a17:90a:b38c:: with SMTP id e12mr35243765pjr.114.1571043147713;
        Mon, 14 Oct 2019 01:52:27 -0700 (PDT)
Received: from athena.bobrowski.net ([120.18.82.202])
        by smtp.gmail.com with ESMTPSA id k17sm10138089pgh.30.2019.10.14.01.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 01:52:27 -0700 (PDT)
Date:   Mon, 14 Oct 2019 19:52:18 +1100
From:   Matthew Bobrowski <mbobrowski@mbobrowski.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2 v3] iomap: Waiting for IO in iomap_dio_rw()
Message-ID: <20191014085218.GA6102@athena.bobrowski.net>
References: <20191014082418.13885-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014082418.13885-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 14, 2019 at 10:26:01AM +0200, Jan Kara wrote:
> Original motivation:
> 
> when doing the ext4 conversion of direct IO code to iomap, we found it very
> difficult to handle inode extension with what iomap code currently provides.
> Ext4 wants to do inode extension as sync IO (so that the whole duration of
> IO is protected by inode->i_rwsem), also we need to truncate blocks beyond
> end of file in case of error or short write. Now in ->end_io handler we don't
> have the information how long originally the write was (to judge whether we
> may have allocated more blocks than we actually used) and in ->write_iter
> we don't know whether / how much of the IO actually succeeded in case of AIO.
> 
> Thinking about it for some time I think iomap code makes it unnecessarily
> complex for the filesystem in case it decides it doesn't want to perform AIO
> and wants to fall back to good old synchronous IO. In such case it is much
> easier for the filesystem if it just gets normal error return from
> iomap_dio_rw() and not just -EIOCBQUEUED.
> 
> The first patch in the series adds argument to iomap_dio_rw() to wait for IO
> completion (internally iomap_dio_rw() already supports this!) and the second
> patch converts XFS waiting for unaligned DIO write to this new API.

Ah, wonderful, I was waiting for this to come through.

I'll rebase my EXT4 direct I/O port on top of these patches and apply
the discussed changes. Any objections? :)

--<M>--
