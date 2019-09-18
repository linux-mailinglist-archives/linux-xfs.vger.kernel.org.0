Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07466B6879
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 18:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfIRQtm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 12:49:42 -0400
Received: from verein.lst.de ([213.95.11.211]:34546 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfIRQtl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 12:49:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E234C68B20; Wed, 18 Sep 2019 18:49:38 +0200 (CEST)
Date:   Wed, 18 Sep 2019 18:49:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_release
Message-ID: <20190918164938.GA19316@lst.de>
References: <20190916122041.24636-1-hch@lst.de> <20190916122041.24636-2-hch@lst.de> <20190916125311.GB41978@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916125311.GB41978@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:53:11AM -0400, Brian Foster wrote:
> The caller might not care if this call generates errors, but shouldn't
> we care if something fails? IOW, perhaps we should have an exit path
> with a WARN_ON_ONCE() or some such to indicate that an unhandled error
> has occurred..?

Not sure there is much of a point.  Basically all errors are either
due to a forced shutdown or cause a forced shutdown anyway, so we'll
already get warnings.
