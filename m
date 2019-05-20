Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579FD23809
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfETNbr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:31:47 -0400
Received: from verein.lst.de ([213.95.11.211]:52738 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730693AbfETNbr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:31:47 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 8BF0E227A83; Mon, 20 May 2019 15:31:25 +0200 (CEST)
Date:   Mon, 20 May 2019 15:31:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bryan Gurney <bgurney@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Message-ID: <20190520133125.GA8951@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-12-hch@lst.de> <20190520131232.GB31317@bfoster> <20190520131946.GA8717@lst.de> <CAHhmqcQaFiQjyfFq0yQQTHrEAMJ68JBN4dZfD6nXZ6DfKPtDiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhmqcQaFiQjyfFq0yQQTHrEAMJ68JBN4dZfD6nXZ6DfKPtDiQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 09:27:37AM -0400, Bryan Gurney wrote:
> It's probably to guard against an assignment in a while / if / etc. statement.
> 
> In other words: Are you sure you didn't intend the following?
> 
>      while (ctx == list_first_entry_or_null(list,
>                      struct xfs_cil_ctx, iclog_entry)) {
> 
> (I've stumbled on a bug like this before, so I figured I'd ask, just
> to be certain.)

Yes, I'm sure.  I'm iterating the list to remove each entry from it
from start to end.
