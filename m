Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667D33C7EEF
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 09:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhGNHEm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 03:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238245AbhGNHEl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:04:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F096C061574
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 00:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7WwolqtDLIs9Ob2iKh8bgTto4l5PZ/EjsbYAfsGb2GA=; b=TbaRJcHAxqoTdD/y5phUh6BT+7
        Yr4ZER5W+8lnwDgyNPZXv+OrWG32hZKiO1KeLHeqmo088LRO5x/y2qyTrdpBogJBYztlsc08ivtAh
        es71CxM5CkMOItqLQFJdWPJQXLWjTR2sL79ZyGi7CYbUGhYTSooYMY3cXzD7TpWyEfzM0OmHvf5qH
        e7elHFATaESAaMfe4s6pzT9rJ0u2jymLnDQCyzASiIv61u2W7QbhSwrXzN2aNNAqOgRGU9Osyaxpo
        mn73/fNuA8OvmbDJPnVpbb6JlNL5QdKi2RPHSFEJ+DKpt5CyKdWOCY46lUMIpiibvhlBxzKPM5q/Q
        ulgDBtkw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YtW-001wXm-Gr; Wed, 14 Jul 2021 07:01:32 +0000
Date:   Wed, 14 Jul 2021 08:01:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: reflect sb features in xfs_mount
Message-ID: <YO6LwjbpHYn4uVvR@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently on-disk feature checks require decoding the superblock
> fileds and so can be non-trivial. We have almost 400 hundred
> individual feature checks in the XFS code, so this is a significant
> amount of code. To reduce runtime check overhead, pre-process all
> the version flags into a features field in the xfs_mount at mount
> time so we can convert all the feature checks to a simple flag
> check.
> 
> There is also a need to convert the dynamic feature flags to update
> the m_features field. This is required for attr, attr2 and quota
> features. New xfs_mount based wrappers are added for this.

Nice!  I've been thinking about something like this for a while to
start decoupling the mount structure from the log sb, similar to what
we did for the inode.

Reviewed-by: Christoph Hellwig <hch@lst.de>
