Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F47F24DB
	for <lists+linux-xfs@lfdr.de>; Tue, 21 Nov 2023 05:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjKUEfZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Nov 2023 23:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKUEfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 23:35:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA8310C;
        Mon, 20 Nov 2023 20:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PUIg+xnvBUG8laixsBBSvmt46H
        dmYShtYi4ePUDDuX/bRbidMmNUib/MfRO3JEosEXDSchfFVZaauDcz7PvVhT+IvVUhMU4MLtW/HOo
        PMUF/OX7SGPaVmdPw4jDzecIb9/z/AgRd5gWxaM7qsbd3QlhYxfTgaK3Dc7nM7vJQ3PGfF18fWxJu
        Quq39zru0tjlU+k7NyIeMGAltoFHYjISO5PxkIM4t/9E5nZ1jXMSItGMPpOxH+rmPFu7qNZxnFTUj
        BGt0Xfbw6yDhZy+b1Jt0EJhc+ElvOGk5clr85DcQztNNru45jnHW7TUL4kp4kb8mODsNP48Mh3Jk0
        PO48XwNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5ITm-00FbEe-07;
        Tue, 21 Nov 2023 04:35:18 +0000
Date:   Mon, 20 Nov 2023 20:35:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/601: move this to tests/generic
Message-ID: <ZVwzhcOEcGc7Aqxa@infradead.org>
References: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
 <170050891446.536459.11166010762932928186.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050891446.536459.11166010762932928186.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
