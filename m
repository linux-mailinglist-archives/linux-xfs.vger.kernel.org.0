Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86777C643A
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 06:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347042AbjJLEvu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 00:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343533AbjJLEvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 00:51:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65140BE
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 21:51:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D80FB6732D; Thu, 12 Oct 2023 06:51:44 +0200 (CEST)
Date:   Thu, 12 Oct 2023 06:51:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: prevent rt growfs when quota is enabled
Message-ID: <20231012045144.GB1637@lst.de>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs> <169704720365.1773263.12533098463437598674.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720365.1773263.12533098463437598674.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
