Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF6210B59
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 14:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgGAMzE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 08:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730520AbgGAMzD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 08:55:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1604DC03E979
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nI7VXwmRFjmkso2zqFsCKVH7Z5T5VZfIzlngG+KAuOc=; b=lRMJbgtFsbhn6FlYPcLpC51bi0
        6No7KKA9qs48KpP4pOuZtx75rZrArHqGkYrlqGQmZD9+GVsW9weWJRq94o4kz4lduugD47xfPix9w
        RWvDDDm5WsL7yNkxi0IqvrzB6/waUN9vzosyKEO35rN5nDtlwH34lEFwCyb2VBhYyO34r1cvdqW3x
        kT8CXpM9dbp1aOaxQEdDQTvT9X1xXiLhgyusYjoONPzIl+JByf5fhmhZrF7+37e5GbI3CBxIF1wdt
        3m1bvKtItKH01g2UmZHzujgs6wBTQiEWSll+1MC/Ke+IM17s49RDTaYWZ2dmzN9ljsKaWxFGGh+eq
        z6yKY8/A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqcGT-0003us-Hz; Wed, 01 Jul 2020 12:55:01 +0000
Date:   Wed, 1 Jul 2020 13:55:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfsprogs: xfs_quota command error message improvement
Message-ID: <20200701125501.GA15006@infradead.org>
References: <20200701125002.623230-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701125002.623230-1-billodo@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 07:50:02AM -0500, Bill O'Donnell wrote:
> Make the error messages for rudimentary xfs_quota commands
> (off, enable, disable) more user friendly, instead of the
> terse sys error outputs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
