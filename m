Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683416DF4B9
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Apr 2023 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDLMKc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Apr 2023 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjDLMKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:10:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF2959D3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oJiQ2FtjeSyrIgleGWv/qLbqcQMOJGQ7h2XgDVk6x6k=; b=kHqGPIIr09rhpNp0GnLdYK0gFY
        KuSgvClthjEunAgvRyCcJJTMuDW09oMajJdnNod9JlajPTXvRCe91oppUEabwUCsKDb8mTpJ82mSC
        0DCnSBOePIkTnp+ynDT8mB2xasHfB0jSUpMIjSwg7u190usPkFMU9yqgLEj4lVAvkuYqyqd2vYKqh
        rByZX0xIIzfxpJnzgb603TtC8gNsCQJdYyjKlV2od9rk/G3tsb5s6YQCAliWFdX0EF1Efs948LVSx
        gb64W2qsZ/xvyHmG8Z2RfoMXIvXbjecYQbReDfnvjn0L2WiVil6nidoU+wFCE4RkA5ueP/kN6Le0S
        RJ6QRzzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZIp-0032gU-15;
        Wed, 12 Apr 2023 12:10:19 +0000
Date:   Wed, 12 Apr 2023 05:10:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove WARN when dquot cache insertion fails
Message-ID: <ZDafq+psGOwbQP95@infradead.org>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411232342.233433-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:23:41AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It just creates unnecessary bot noise these days.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
