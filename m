Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8A41E29
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 09:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407000AbfFLHp5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 03:45:57 -0400
Received: from verein.lst.de ([213.95.11.211]:57628 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406508AbfFLHp4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 03:45:56 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0775868AFE; Wed, 12 Jun 2019 09:45:28 +0200 (CEST)
Date:   Wed, 12 Jun 2019 09:45:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix
Message-ID: <20190612074527.GA20491@lst.de>
References: <20190611151007.13625-1-hch@lst.de> <20190612010922.GA17522@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612010922.GA17522@ming.t460p>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 09:09:23AM +0800, Ming Lei wrote:
> We have to backport the fixes to -stable tree, and downstream need to
> ship the fix too.
> 
> The issue is quite serious because the leak is in IO path and the whole
> system ram can be used up easily on some workloads. So I think the fix
> should be for 5.2, however, regression risk might be increased by
> pulling cleanup & re-factor in now.
> 
> I really appreciate you may cook a fix-only patch for this issue.
> Especially the change in add pc page code isn't necessary for fixing
> the issue.

Patches 3 and 4 have no dependencies on 1 and 2, and should have
arguably been ordered first in the series.
