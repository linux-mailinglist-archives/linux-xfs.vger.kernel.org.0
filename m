Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD0E5FF851
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Oct 2022 05:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJODq5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Oct 2022 23:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJODqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 23:46:54 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B276659EF
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 20:46:52 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a25so8160497ljk.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 20:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MkfEc6MRH89syDpHugGsyUmRoLIB+ex3PIfLXsCoWS0=;
        b=gEmFGh3NXRw6/CO37/BbCOnaFIAJjsGtGAg5GWjA4I0BlJ29mvjG5rEgvwb8qOT+Q/
         czOpsQZmICCz2I73sYOilqhvCi+C/b7lvozAusqkZrsKDBb7o/7LmVfklJcOzaKbxEI4
         RfcjQr2ODyWFuubPe6r7IM+3qrmsm6TaLFFi83b4KwI0qqkAtFLFaGaMMA6qZtYjJGnD
         luihn7IFYQHeav96YmHGd9Jp+cEB+psymqD16ZjhpqM8jlIdIraf/N9Ztf5p42HHa27Y
         cERp31/0DCl8IqpENorJW1duKl0ZXC+zFXdCGw7hpuHCcqznQNDn16sBuhf+Pvx+B4xr
         fW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkfEc6MRH89syDpHugGsyUmRoLIB+ex3PIfLXsCoWS0=;
        b=FJLfeFYZzepsiWaLYGvhpKvVbCQq189IO8hKkxCpZzRnLxxQfogRQkACTvZLq+yZUQ
         I8JwTO/h2VckwvA0HZIEHPyZzU2XdBKi91qTPxaLTxli+2cheastgGMJvHrGSdjKRY1x
         Bqd00BXKSlAmfGkeTrVQ/LLsdfInrYgwbbv/U1NgWzi8YuHM4GAK2RC/vA8bEzg3mja0
         ZeCaaptaVSVhOH8jEfjUa+h9vt7My0XxjK1IOFoi+qGgR5UWHmsCwSHGTaaUvqZJtAgx
         f81eUg4u/GdahaaptNlJ4jUSxJYmm9Gh54P2RPOCZL3URJk6UQJ02RuBAyjQU/zod4fH
         sb3g==
X-Gm-Message-State: ACrzQf1BrH6Aai0K4jMh7lAGK2ciYRWAY+EClqkG2eeO1xIMafNb8ULv
        pcszSCRGrFtVkLZLsjXyxvDtvxwGxXOMR9KPUbI=
X-Google-Smtp-Source: AMsMyM4tt0Dq+59FHSBs534f8Nm5x03Y9ue5b9JcnEZqo4HqUrjlSNlKEI9bclmiigeb+22NbDJK/1FLH5uvH1RyF9k=
X-Received: by 2002:a2e:9658:0:b0:26f:d3be:e7b4 with SMTP id
 z24-20020a2e9658000000b0026fd3bee7b4mr337154ljh.466.1665805610549; Fri, 14
 Oct 2022 20:46:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:bd03:0:0:0:0:0 with HTTP; Fri, 14 Oct 2022 20:46:49
 -0700 (PDT)
Reply-To: georgebrownlevi@outlook.com
From:   Levi Chambers Association <ktradingsltd@gmail.com>
Date:   Sat, 15 Oct 2022 03:46:49 +0000
Message-ID: <CADL+5vhEq8oJKzed3-SF74p3nAxKaOENo_M8zXc36VedHvektw@mail.gmail.com>
Subject: Wong
To:     georgebrownlevi@outlook.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-- 
Do you received my previous email?
