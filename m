Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390D37D12E6
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Oct 2023 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377804AbjJTPe5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Oct 2023 11:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377819AbjJTPey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 11:34:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C908C10D3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 08:34:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BB8C433C7;
        Fri, 20 Oct 2023 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697816089;
        bh=5Vfp42h2ec3FM2xIhyLmllTvuIX/wJDqWOWAtyvB280=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVqwnuHfdGF9EEg/RtDd5M/BQhpEykffgl81cRXX1GUOlRH7V36bv1U+5oHJKnquk
         4Ai+pBCi8zGdyaV7kLExXSukAdDmFRixVZzCoqFZFTtH/Sx6gb1rvx5Vht2jR3ZRug
         kmG2QWyYd0eXOO5/QCcOSP/7bWi7QF+jaz3Gmp6LHEHKs/8N0VsnTehHeBEExIoy0V
         KGYmk8mv6eXHNypRXR086Paghf0A77U1v2uTD1hhFj5sGjyBpa9m29RwMZveC49w2X
         IZMfLRcVYAjBOLIPnp7+tw2CPjeGl9P4P3X4IUvgp/LnbdOFvr45/KOy99oXr6eMDQ
         YfTPjk/G4TDog==
Date:   Fri, 20 Oct 2023 08:34:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231020153448.GR3195650@frogsfrogsfrogs>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS92TizgnKHdBtDb@infradead.org>
 <20231019200411.GN3195650@frogsfrogsfrogs>
 <ZTIY8jE9vK6A0FE3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTIY8jE9vK6A0FE3@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 11:06:42PM -0700, Christoph Hellwig wrote:
> On Thu, Oct 19, 2023 at 01:04:11PM -0700, Darrick J. Wong wrote:
> > Well... the stupid answer is that I augmented generic/176 to try to race
> > buffered and direct reads with cloning a million extents and print out
> > when the racing reads completed.  On an unpatched kernel, the reads
> > don't complete until the reflink does:
> 
> > So as you can see, reads from the reflink source file no longer
> > experience a giant latency spike.  I also wrote an fstest to check this
> > behavior; I'll attach it as a separate reply.
> 
> Nice.  I guess write latency doesn't really matter for this use
> case?

Nope -- they've gotten libvirt to tell qemu to redirect vm disk writes
to a new sidecar file.  Then they reflink the original source file to
the backup file, but they want qemu to be able to service reads from
that original source file while the reflink is ongoing.  When the backup
is done, they commit the sidecar contents back into the original image.

It would be kinda neat if we had file range locks.  Regular progress
could shorten the range as it makes progress.  If the thread doing the
reflink could find out that another thread has blocked on part of the
file range, it could even hurry up and clone that part so that neither
reads nor writes would see enormous latency spikes.

Even better, we could actually support concurrent reads and writes to
the page cache as long as the ranges don't overlap.  But that's all
speculative until Dave dumps his old ranged lock patchset on the list.

--D
