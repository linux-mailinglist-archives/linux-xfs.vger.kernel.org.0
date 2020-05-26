Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A6E1C110A
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 12:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgEAKms (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 06:42:48 -0400
Received: from verein.lst.de ([213.95.11.211]:45669 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbgEAKms (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 May 2020 06:42:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8818368BFE; Fri,  1 May 2020 12:42:45 +0200 (CEST)
Date:   Fri, 1 May 2020 12:42:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: pass a commit_mode to xfs_trans_commit
Message-ID: <20200501104245.GA28237@lst.de>
References: <20200409073650.1590904-1-hch@lst.de> <20200501080703.GA17731@infradead.org> <20200501102403.GA37819@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501102403.GA37819@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 06:24:03AM -0400, Brian Foster wrote:
> I recall looking at this when it was first posted and my first reaction
> was that I didn't really like the interface. I decided to think about it
> to see if it grew on me and then just lost track (sorry). It's not so
> much passing a flag to commit as opposed to the flags not directly
> controlling behavior (i.e., one flag means sync if <something> is true,
> another flag means sync if <something else> is true, etc.) tends to
> confuse me. I don't feel terribly strongly about it if others prefer
> this pattern, but I still find the existing code more readable.
> 
> I vaguely recall thinking it might be nice if we could dump this into
> transaction state to avoid the aforementioned logic warts, but IIRC that
> might not have been possible for all users of this functionality..

Moving the flag out of the transaction structure was the main motivation
for this series - the fact that we need different arguments to
xfs_trans_commit is just a fallout from that.  The rationale is that
I found it highly confusing to figure out how and where we set the sync
flag vs having it obvious in the one place where we commit the
transaction.
