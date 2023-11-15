Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2845C7E36D1
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Nov 2023 09:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjKGIjD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Nov 2023 03:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjKGIjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:39:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A539F3
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nbUjxoIumnm750KoJ0VGt6TElO
        OvtR6/lLYI2wO4Vt+gHfiv+FXLp31nprrMRU8oJD4OeGs68cCcyu1ws/bruDEvnS1/s/DrVUf0549
        rMcGJVHGTxkR8J4e5ani79LhLAye1ACrXaZPS2eMuKmIdgmGFPmSgm2Dimb5+TaZQMW143bfvn1Rl
        Ljv2waeA65m7SzowimkVBie37kDwUOlaPcFtNj6Cu4AgFTFXC56p0aKv5AGU7MPNVs62mDRAW+P30
        4PMptRhOIRH9pPEEVxEbI8bVaA7ZLUcN1NhpA/oZLa+OspiByvPdpyErgOzobMt5nuAMWPZLa1iDE
        I+gPt6rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0Hbw-000pwL-2w;
        Tue, 07 Nov 2023 08:39:00 +0000
Date:   Tue, 7 Nov 2023 00:39:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub_fail: fix sendmail detection
Message-ID: <ZUn3pGdYf20QJWJd@infradead.org>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
 <168506073887.3745766.3554648508638613549.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506073887.3745766.3554648508638613549.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
