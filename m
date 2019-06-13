Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0395C43ED2
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732915AbfFMPxS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:53:18 -0400
Received: from verein.lst.de ([213.95.11.211]:36784 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfFMJD0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 05:03:26 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id B695568B02; Thu, 13 Jun 2019 11:02:57 +0200 (CEST)
Date:   Thu, 13 Jun 2019 11:02:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix
Message-ID: <20190613090257.GA13708@lst.de>
References: <20190611151007.13625-1-hch@lst.de> <20190612010922.GA17522@ming.t460p> <20190612074527.GA20491@lst.de> <20190612101111.GA16000@ming.t460p> <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 03:02:10AM -0600, Jens Axboe wrote:
> >> Patches 3 and 4 have no dependencies on 1 and 2, and should have
> >> arguably been ordered first in the series.
> > 
> > OK, that is good to make patch 3 &4 into 5.2, I will give a review
> > soon.
> 
> I'll echo Mings sentiments here, for the series.

And what does that actually mean?  Do you want me to just resend
3 and 4, or can you just pick them up?
