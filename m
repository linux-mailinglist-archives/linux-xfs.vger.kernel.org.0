Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6FA62B70F
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Nov 2022 10:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiKPJ7I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Nov 2022 04:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiKPJ7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 04:59:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7EF9591
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 01:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4DB6B81C0D
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 09:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2185C433D6
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668592740;
        bh=CiJJLEHuA+XDkiwANqSuYREOQXTGAnIV13Fjtzwf2SI=;
        h=Date:From:To:Subject:From;
        b=Rp8Eh5yf1d8CVLaMhzTNwB4ptwV4U6u2/aKGi+FouKyw0lqTPzg9+9+7JR8PHqjRb
         rcRJjKj0WXWqTytFJeO6oZNjVdKMiSWOVmcUTGCdhEIwKfY9un/7TinGYcwhrBovpv
         Z+W3akaP4UvYc+gG2u0GbHgiEwMbe5tHLCQevb26285JmZ2diTV2bcwH1j3tRcYK8O
         FwzZcWjZbvqAXFo5mVpH2pX0bQKgRl3hKRb1lu4Ms0aXVbd8+XAir5AMVzT6R4Ljnj
         +6vrYMbNLyKjsfI1sTeZeP5cy2EMHHRQN146JARY+gvKE0vPsB28tWqU96RTfJgJcB
         FmLHxM6t0KymA==
Date:   Wed, 16 Nov 2022 10:58:56 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <20221116095856.6q5ndgpoigifk2ry@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

the xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=for-next

has just been updated to match the master branch. This is just a follow-up sync
for the xfsprogs-6.0.0 release from yesterday, and all staging for the next
release will be done on top of that.

Cheers.

-- 
Carlos Maiolino
