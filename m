Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E312C72546F
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Jun 2023 08:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbjFGGjT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jun 2023 02:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbjFGGjQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 02:39:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD38A1BCE
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 23:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q4VI43v4bPiiSFPvsjMFwRjcBR3mUTBU/3Ovslzio8U=; b=vOixDa33R/rpHelsCpRcylZFzq
        AcFQtHt0hgbSobIy09SvLFyvrmRWXkRb8kxOoMva/vKl+m7yRIoBjsUfZDLzeb99kwxwXIiQl8eqz
        gBMzocWTEtaZA+tZGt+yj1dRLg9LZ3tblQrej/IREVHtN86CHuBPJV4pw7uyGP8eoqaDKvU+j47W5
        bGcSQsutHgLMvrVyG3RrjA9HVn1kSkbDAGOwGd4RKLAcGjOGWZmSOt0TDMKdHv7uQ2xP8bQw5UOYX
        8Tn/4yhnixGbgcV2SSAcQg+JOWhlVAJuMJKTgNovcz/yRFzPQcK8opDg8P/v/c3zc2ENFH3A4VlsT
        4zfJaPCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q6moy-004ams-1Q;
        Wed, 07 Jun 2023 06:39:04 +0000
Date:   Tue, 6 Jun 2023 23:39:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <ZIAmCHghf8Acr26I@infradead.org>
References: <20230606151122.853315-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606151122.853315-1-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 05:11:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Comment the code out so kernel test robot stop complaining about it
> every single test build.

Err, what?  #if 0ing commit coe is a complete no-go.  If this code
is dead it should be removed.

